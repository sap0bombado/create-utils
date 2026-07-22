--!strict
const UserInputService = game:GetService("UserInputService")

type Connection = {
	connected: boolean,
	disconnect: (self: Connection) -> (),
}

type Signal<T... = ...any> = {
	connect: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	once: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	disconnectAll: (self: Signal<T...>) -> (),

	fire: (self: Signal<T...>, T...) -> (),
	wait: (self: Signal<T...>) -> T...,
}

type InputMap = {
	[Enum.KeyCode | Enum.UserInputType]: {
		[boolean]: {
			[Enum.UserInputState]: Signal<InputObject>,
		},
	},
}

const pkg = script.Parent :: any
const createSignal = (require)(pkg.createSignal)
const createScope = (require)(pkg.createScope)

const DEFAULT_INPUT_STATE = Enum.UserInputState.Begin
const DEFAULT_GAME_PROCESSED = false

const signalInputMap: InputMap = {}
local listenerScope

const function getInputSignal(
	input: Enum.KeyCode | Enum.UserInputType,
	state: Enum.UserInputState,
	gameProcessed: boolean
): Signal<InputObject>?
	if not signalInputMap[input] then
		return nil
	end

	if not signalInputMap[input][gameProcessed] then
		return nil
	end

	if not signalInputMap[input][gameProcessed][state] then
		return nil
	end

	return signalInputMap[input][gameProcessed][state]
end

const function getOrCreateInputSignal(
	input: Enum.KeyCode | Enum.UserInputType,
	state: Enum.UserInputState,
	gameProcessed: boolean
): Signal<InputObject>
	if not signalInputMap[input] then
		signalInputMap[input] = {}
	end

	if not signalInputMap[input][gameProcessed] then
		signalInputMap[input][gameProcessed] = {}
	end

	if not signalInputMap[input][gameProcessed][state] then
		signalInputMap[input][gameProcessed][state] = createSignal() :: Signal<InputObject>
	end

	return signalInputMap[input][gameProcessed][state]
end

const function startListeningForInputs()
	const function onInputBegan(inputObject: InputObject, gameProcessed: boolean)
		const signal = getInputSignal(inputObject.KeyCode, inputObject.UserInputState, gameProcessed)

		if signal then
			signal:fire(inputObject)
		end
	end

	const function onInputEnded(inputObject: InputObject, gameProcessed: boolean)
		const signal = getInputSignal(inputObject.KeyCode, inputObject.UserInputState, gameProcessed)

		if signal then
			signal:fire(inputObject)
		end
	end

	const scope = createScope()

	scope(UserInputService.InputBegan:Connect(onInputBegan))
	scope(UserInputService.InputEnded:Connect(onInputEnded))

	return scope
end

const function createInput(
	input: Enum.KeyCode | Enum.UserInputType,
	state: Enum.UserInputState?,
	gameProcessed: boolean?
): Signal<InputObject>
	if not listenerScope then
		listenerScope = startListeningForInputs()
	end

	return getOrCreateInputSignal(
		input,
		state or DEFAULT_INPUT_STATE,
		if gameProcessed == nil then DEFAULT_GAME_PROCESSED else gameProcessed
	)
end

return createInput
