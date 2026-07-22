--!strict
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
local ORDERED_METHOD_NAMES: { string } = {
	"Destroy",
	"Clear",
	"Delete",
	"StopAll",
	"Stop",
	"DisconnectAll",
	"Disconnect",
	"Unbind",
	"RemoveAll",
	"Remove",
}

local function clean(scopeTraceback: string, item: any)
	local typeOfItem = typeof(item)

	if typeOfItem == "table" then
		local foundMethod = false

		for _, methodName: string in ORDERED_METHOD_NAMES do
			local method: ((any) -> ())? = item[methodName] or item[methodName:gsub("^%l", string.lower, 1)]

			if method == nil or typeof(method) ~= "function" then
				continue
			end

			method(item)
			foundMethod = true

			break
		end

		if foundMethod == true then
			return
		end

		warn("Couldn't find a cleanup method for object:", item, "\nScope created at:", scopeTraceback)
	elseif typeOfItem == "Instance" then
		(item :: Instance):Destroy()
	elseif typeOfItem == "RBXScriptConnection" then
		(item :: RBXScriptConnection):Disconnect()
	elseif typeOfItem == "function" then
		item()
	elseif typeOfItem == "thread" then
		task.cancel(item)
	else
		warn(`Unknown type: {typeOfItem} value: `, item, "\nScope created at:", scopeTraceback)
	end
end

local function cleanup(scopeTraceback: string, memory: { unknown })
	for i = #memory, 1, -1 do
		clean(scopeTraceback, memory[i])
		memory[i] = nil
	end

	table.clear(memory)
end

local function add(memory: { unknown }, items: { unknown })
	for _, item: any in items do
		table.insert(memory, item)
	end
end

export type Scope = <T...>(T...) -> T...

local function createScope<T...>(size: number?, ...: T...): (Scope, T...)
	local scopeTraceback = debug.traceback(nil, 2)
	local scopeMemory: { any } = size ~= nil and table.create(size) or {}

	add(scopeMemory, { ... })

	return function<T...>(...: T...): T...
		if select("#", ...) == 0 then
			cleanup(scopeTraceback, scopeMemory)
			return nil :: any
		end

		add(scopeMemory, { ... })

		return ...
	end,
		...
end

return createScope
