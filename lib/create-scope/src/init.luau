--!strict
--!optimize 2
--[[
	Creates a memory object that can be used to store and clean up resources.

	MIT License

	Copyright (c) 2026 Diego Bandeira

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
--]]

local function resolve(item: any): ((any) -> ())?
	local m = item.Destroy
	if m and typeof(m) == 'function' then return m :: (any) -> () end

	m = item.destroy
	if m and typeof(m) == 'function' then return m :: (any) -> () end

	m = item.DisconnectAll
	if m and typeof(m) == 'function' then return m :: (any) -> () end

	m = item.disconnectAll
	if m and typeof(m) == 'function' then return m :: (any) -> () end

	m = item.Disconnect
	if m and typeof(m) == 'function' then return m :: (any) -> () end

	m = item.disconnect
	if m and typeof(m) == 'function' then return m :: (any) -> () end

	m = item.Cleanup
	if m and typeof(m) == 'function' then return m :: (any) -> () end

	m = item.cleanup
	if m and typeof(m) == 'function' then return m :: (any) -> () end

	return nil
end

@native
local function clean(item: any)
	local typeOfItem = typeof(item)

	if typeOfItem == 'table' or typeOfItem == 'userdata' then
		local method = resolve(item)

		if method then
			method(item)
			return
		end

		error('Couldn\'t find a cleanup method for object:', item)
	elseif typeOfItem == 'Instance' then
		(item :: Instance):Destroy()
	elseif typeOfItem == 'RBXScriptConnection' then
		(item :: RBXScriptConnection):Disconnect()
	elseif typeOfItem == 'function' then
		item()
	elseif typeOfItem == 'thread' then
		task.cancel(item)
	else
		error(`Unknown type: {typeOfItem} value: `, item)
	end
end

@native
local function cleanup(memory: { any })
	for i = #memory, 1, -1 do
		clean(memory[i])
	end

	table.clear(memory)
end

@native
local function add(memory: { any }, ...: any)
	local mlen = #memory
	local n = select('#', ...)
	for i = 1, n do
		memory[i + mlen] = select(i, ...)
	end
end

export type Scope = <T...>(T...) -> T...

local function createScope<T...>(size: number?, ...: T...): (Scope, T...)
	local memory: { any } = size ~= nil and table.create(size) or {}

	add(memory, ...)

	local function scope<U...>(...: U...): U...
		if select('#', ...) == 0 then
			cleanup(memory)
			return nil :: any
		end

		add(memory, ...)

		return ...
	end

	return scope, ...
end

return createScope
