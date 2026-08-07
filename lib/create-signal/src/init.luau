--!strict
--!optimize 2
export type Connection = {
	connected: boolean,
	disconnect: (self: Connection) -> (),
}

export type Signal<T... = ...any> = ConnectPermission<T...> & FirePermission<T...> & DestroyPermission<T...>

export type DestroyPermission<T... = ...any> = {
	disconnectAll: (self: DestroyPermission<T...>) -> (),
	destroy: (self: DestroyPermission<T...>) -> (),
}

export type FirePermission<T... = ...any> = {
	fire: (self: FirePermission<T...>, T...) -> (),
}

export type ConnectPermission<T... = ...any> = {
	connect: (self: ConnectPermission<T...>, callback: (T...) -> ()) -> Connection,
	once: (self: ConnectPermission<T...>, callback: (T...) -> ()) -> Connection,
	wait: (self: ConnectPermission<T...>, timeout: number?) -> T...,
}

type InternalConnection = {
	_signal: InternalSignal,
	_previous: InternalConnection?,
	_next: InternalConnection?,
	_callback: (...any) -> (),

	connected: boolean,
	disconnect: (self: InternalConnection) -> (),
}

type InternalSignal = {
	_head: InternalConnection?,
	_tail: InternalConnection?,

	connect: (self: InternalSignal, callback: (...any) -> ()) -> InternalConnection,
	once: (self: InternalSignal, callback: (...any) -> ()) -> InternalConnection,
	disconnectAll: (self: InternalSignal) -> (),

	fire: (self: InternalSignal, ...any) -> (),
	wait: (self: InternalSignal) -> ...any,
}

local freeThreads: { thread } = {}

-- ** lib ** --
local coroutineRuning = coroutine.running
local coroutineCreate = coroutine.create
local coroutineResume = coroutine.resume
local coroutineYield = coroutine.yield
local taskSpawn = task.spawn
local tableInsert = table.insert

local function run(callbackAsync: (...any) -> (), thread: thread, ...: any)
	callbackAsync(...)
	tableInsert(freeThreads, thread)
end

local function yielder()
	while true do
		run(coroutineYield())
	end
end

-- ** connection impl ** --
local function disconnect(self: InternalConnection)
	if not self.connected then return end

	self.connected = false

	local signal = self._signal
	local previous = self._previous
	local _next = self._next

	if previous then
		previous._next = _next
	else
		signal._tail = _next
	end

	if _next then
		_next._previous = previous
	else
		signal._head = previous
	end
end

@native
local function disconnectAll(self: InternalSignal)
	local connection = self._tail

	while connection do
		local _next = connection._next

		connection.connected = false
		connection._next = nil
		connection._previous = nil

		connection = _next
	end

	self._head = nil
	self._tail = nil
end

local function destroy(self: InternalSignal)
	disconnectAll(self)
	table.clear(self)
end

-- ** signal impl ** --
local function connect(self: InternalSignal, callback: (...any) -> ())
	local head = self._head

	local connection: InternalConnection = {
		_signal = self,
		_previous = head,
		_callback = callback,

		connected = true,
		disconnect = disconnect,
	}

	if head then
		head._next = connection
	else
		self._tail = connection
	end

	self._head = connection

	return connection
end

local function once(self: InternalSignal, callback: (...any) -> ())
	local connection: InternalConnection

	local function connectListener(...: any)
		disconnect(connection)
		callback(...)
	end

	connection = connect(self, connectListener)

	return connection
end

local function _wait(self: InternalSignal, timeout: number?): ...any
	local runningThread = coroutineRuning()
	local cancelled = false
	local connection: InternalConnection

	if timeout then task.delay(timeout, function()
		if cancelled then return end

		cancelled = true
		connection:disconnect()
		taskSpawn(runningThread)
	end) end

	local function onceListener(...: any)
		if cancelled then return end
		cancelled = true
		taskSpawn(runningThread, ...)
	end

	connection = once(self, onceListener)

	return coroutineYield()
end

@native
local function fire(self: InternalSignal, ...: any)
	local connection = self._tail

	while connection do
		local threadLength = #freeThreads

		if threadLength == 0 then
			local thread = coroutineCreate(yielder)
			coroutineResume(thread)

			taskSpawn(thread, connection._callback, thread, ...)
		else
			local thread = freeThreads[threadLength]
			freeThreads[threadLength] = nil

			taskSpawn(thread, connection._callback, thread, ...)
		end

		connection = connection._next
	end
end

local function createSignal<T...>(): Signal<T...>
	return {
		connect = connect,
		once = once,
		fire = fire,
		wait = _wait,

		disconnectAll = disconnectAll,
		destroy = destroy,
	} :: any
end

return createSignal
