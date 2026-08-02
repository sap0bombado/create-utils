--!strict
--!optimize 2
export type Connection = {
	connected: boolean,
	disconnect: (self: Connection) -> (),
}

export type Signal<T... = ...any> = {
	connect: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	once: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	disconnectAll: (self: Signal<T...>) -> (),
	destroy: (self: Signal<T...>) -> (),

	fire: (self: Signal<T...>, T...) -> (),
	wait: (self: Signal<T...>, timeout: number?) -> T...,
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

const freeThreads: { thread } = {}

-- ** lib ** --
const coroutineRuning = coroutine.running
const coroutineCreate = coroutine.create
const coroutineResume = coroutine.resume
const coroutineYield = coroutine.yield
const taskSpawn = task.spawn
const tableInsert = table.insert

const function run(callbackAsync: (...any) -> (), thread: thread, ...: any)
	callbackAsync(...)
	tableInsert(freeThreads, thread)
end

const function yielder()
	while true do
		run(coroutineYield())
	end
end

-- ** connection impl ** --
const function disconnect(self: InternalConnection)
	if not self.connected then return end

	self.connected = false

	const signal = self._signal
	const previous = self._previous
	const _next = self._next

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
const function disconnectAll(self: InternalSignal)
	local connection = self._tail

	while connection do
		const _next = connection._next

		connection.connected = false
		connection._next = nil
		connection._previous = nil

		connection = _next
	end

	self._head = nil
	self._tail = nil
end

const function destroy(self: InternalSignal)
	disconnectAll(self)
	table.clear(self)
end

-- ** signal impl ** --
const function connect(self: InternalSignal, callback: (...any) -> ())
	const head = self._head

	const connection: InternalConnection = {
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

const function once(self: InternalSignal, callback: (...any) -> ())
	local connection: InternalConnection

	const function connectListener(...: any)
		disconnect(connection)
		callback(...)
	end

	connection = connect(self, connectListener)

	return connection
end

const function _wait(self: InternalSignal, timeout: number?): ...any
	const runningThread = coroutineRuning()
	local cancelled = false
	local connection: InternalConnection

	if timeout then task.delay(timeout, function()
		if cancelled then return end

		cancelled = true
		connection:disconnect()
		taskSpawn(runningThread)
	end) end

	const function onceListener(...: any)
		if cancelled then return end
		cancelled = true
		taskSpawn(runningThread, ...)
	end

	connection = once(self, onceListener)

	return coroutineYield()
end

@native
const function fire(self: InternalSignal, ...: any)
	local connection = self._tail

	while connection do
		const threadLength = #freeThreads

		if threadLength == 0 then
			const thread = coroutineCreate(yielder)
			coroutineResume(thread)

			taskSpawn(thread, connection._callback, thread, ...)
		else
			const thread = freeThreads[threadLength]
			freeThreads[threadLength] = nil

			taskSpawn(thread, connection._callback, thread, ...)
		end

		connection = connection._next
	end
end

const function createSignal<T...>(): Signal<T...>
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
