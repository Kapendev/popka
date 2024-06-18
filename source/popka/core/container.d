// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT

/// The container module serves as a hub for various data structures.

module popka.core.container;

import popka.core.stdc;

@safe @nogc nothrow:

struct List(T) {
    T[] items;
    size_t capacity;

    @safe @nogc nothrow:

    this(size_t length) {
        foreach (i; 0 .. length) {
            append(T.init);
        }
    }

    this(const(T)[] args) {
        foreach (arg; args) {
            append(arg);
        }
    }

    this(List!T list) {
        foreach (item; list.items) {
            append(item);
        }
    }

    this(FlagList!T list) {
        foreach (item; list.items) {
            append(item);
        }
    }

    T[] opSlice(size_t dim)(size_t i, size_t j) {
        return items[i .. j];
    }

    T[] opIndex() {
        return items[];
    }

    // D calls this when the slice op is used and it works like this: opIndex(opSlice(i, j))
    T[] opIndex(T[] slice) {
        return slice;
    }

    // Returning a ref will let people take a pointer to that value.
    ref T opIndex(size_t i) {
        return items[i];
    }

    @trusted
    void opIndexAssign(const(T) rhs, size_t i) {
        items[i] = cast(T) rhs;
    }

    @trusted
    void opIndexOpAssign(string op)(const(T) rhs, size_t i) {
        mixin("items[i] " ~ op ~ "= cast(T) rhs;");
    }

    size_t opDollar(size_t dim)() {
        return items.length;
    }

    size_t length() {
        return items.length;
    }

    @trusted
    void append(const(T)[] args...) {
        foreach (arg; args) {
            size_t newLength = length + 1;
            if (newLength > capacity) {
                capacity = findListCapacity(newLength);
                items = (cast(T*) realloc(items.ptr, capacity * T.sizeof))[0 .. newLength];
            } else {
                items = items.ptr[0 .. newLength];
            }
            items[$ - 1] = cast(T) arg;
        }
    }

    void remove(size_t i) {
        items[i] = items[$ - 1];
        items = items[0 .. $ - 1];
    }

    T pop() {
        if (length > 0) {
            T temp = items[$ - 1];
            remove(length - 1);
            return temp;
        } else {
            return T.init;
        }
    }

    void resize(size_t length) {
        if (length < this.length) {
            items = items[0 .. length];
        } else {
            foreach (i; 0 .. length - this.length) {
                this.append(T.init);
            }
        }
    }

    @trusted
    void fill(const(T) value) {
        foreach (ref item; items) {
            item = cast(T) value;
        }
    }

    void clear() {
        items = items[0 .. 0];
    }

    @trusted
    void free() {
        if (items.ptr != null) {
            .free(items.ptr);
            items = [];
            capacity = 0;
        }
    }
}

struct FlagList(T) {
    List!T data;
    List!bool flags;
    size_t hotIndex;
    size_t openIndex;

    @safe @nogc nothrow:

    this(size_t length) {
        foreach (i; 0 .. length) {
            append(T.init);
        }
    }

    this(const(T)[] args...) {
        foreach (arg; args) {
            append(arg);
        }
    }

    this(List!T list) {
        foreach (item; list.items) {
            append(item);
        }
    }

    this(FlagList!T list) {
        data.resize(list.data.length);
        flags.resize(list.flags.length);
        foreach (i; 0 .. flags.length) {
            data[i] = list.data[i];
            flags[i] = list.flags[i];
        }
        hotIndex = list.hotIndex;
        openIndex = list.openIndex;
    }

    ref T opIndex(size_t i) {
        if (!flags[i]) {
            assert(0, "ID doesn't exist.");
        }
        return data[i];
    }

    @trusted
    void opIndexAssign(const(T) rhs, size_t i) {
        if (!flags[i]) {
            assert(0, "ID doesn't exist.");
        }
        data[i] = cast(T) rhs;
    }

    @trusted
    void opIndexOpAssign(string op)(const(T) rhs, size_t i) {
        if (!flags[i]) {
            assert(0, "ID doesn't exist.");
        }
        mixin("data[i] ", op, "= cast(T) rhs;");
    }

    size_t length() {
        size_t result = 0;
        foreach (id; ids) {
            result += 1;
        }
        return result;
    }

    bool hasID(size_t id) {
        return id < flags.length && flags[id];
    }

    @trusted
    void append(const(T)[] args...) {
        foreach (arg; args) {
            if (openIndex == flags.length) {
                data.append(arg);
                flags.append(true);
                hotIndex = openIndex;
                openIndex = flags.length;
            } else {
                auto isFull = true;
                foreach (i; openIndex .. flags.length) {
                    if (!flags[i]) {
                        data[i] = arg;
                        flags[i] = true;
                        hotIndex = i;
                        openIndex = i;
                        isFull = false;
                        break;
                    }
                }
                if (isFull) {
                    data.append(arg);
                    flags.append(true);
                    hotIndex = openIndex;
                    openIndex = flags.length;
                }
            }
        }
    }

    void remove(size_t i) {
        if (!flags[i]) {
            assert(0, "ID doesn't exist.");
        }
        flags[i] = false;
        hotIndex = i;
        if (i < openIndex) {
            openIndex = i;
        }
    }

    void resize(size_t length) {
        // I could write more code but I don't think that people will really resize.
        if (length < flags.length) {
            hotIndex = 0;
            openIndex = 0;
        }
        data.resize(length);
        flags.resize(length);
    }

    void fill(const(T) value) {
        data.fill(value);
        flags.fill(true);
        hotIndex = flags.length - 1;
        openIndex = flags.length;
    }

    void clear() {
        data.clear();
        flags.clear();
        hotIndex = 0;
        openIndex = 0;
    }

    void free() {
        data.free();
        flags.free();
        hotIndex = 0;
        openIndex = 0;
    }

    auto ids() {
        struct Range {
            bool[] flags;
            size_t id;

            bool empty() {
                return id == flags.length;
            }
            
            size_t front() {
                return id;
            }
            
            void popFront() {
                id += 1;
                while (id != flags.length && !flags[id]) {
                    id += 1;
                }
            }
        }

        size_t id = 0;
        while (id < flags.length && !flags[id]) {
            id += 1;
        }
        return Range(flags.items, id);
    }

    auto items() {
        struct Range {
            T[] data;
            bool[] flags;
            size_t id;

            bool empty() {
                return id == flags.length;
            }
            
            ref T front() {
                return data[id];
            }
            
            void popFront() {
                id += 1;
                while (id != flags.length && !flags[id]) {
                    id += 1;
                }
            }
        }

        size_t id = 0;
        while (id < flags.length && !flags[id]) {
            id += 1;
        }
        return Range(data.items, flags.items, id);
    }
}

size_t findListCapacity(size_t length) {
    enum defaultCapacity = 64;

    size_t result = defaultCapacity;
    while (result < length) {
        result *= 2;
    }
    return result;
}

struct Grid(T) {
    List!T cells;
    size_t rowCount;
    size_t colCount;

    @safe @nogc nothrow:

    this(size_t rowCount, size_t colCount) {
        resize(rowCount, colCount);
    }

    // TODO: Learn how to slice only rows, ...
    T[] opSlice(size_t dim)(size_t i, size_t j) {
        return items[i .. j];
    }

    T[] opIndex() {
        return cells[];
    }

    T[] opIndex(T[] slice) {
        return slice;
    }

    ref T opIndex(size_t i) {
        return cells[i];
    }

    ref T opIndex(size_t row, size_t col) {
        return cells[colCount * row + col];
    }

    void opIndexAssign(T rhs, size_t i) {
        cells[i] = rhs;
    }

    void opIndexAssign(T rhs, size_t row, size_t col) {
        cells[colCount * row + col] = rhs;
    }

    void opIndexOpAssign(string op)(T rhs, size_t i) {
        mixin("cells[i] " ~ op ~ "= rhs;");
    }

    void opIndexOpAssign(string op)(T rhs, size_t row, size_t col) {
        mixin("cells[colCount * row + col] " ~ op ~ "= rhs;");
    }

    size_t opDollar(size_t dim)() {
        static if (dim == 0) {
            return rowCount;
        } else {
            return colCount;
        }
    }

    size_t length() {
        return cells.length;
    }

    void resize(size_t rowCount, size_t colCount) {
        this.cells.resize(rowCount * colCount);
        this.rowCount = rowCount;
        this.colCount = colCount;
    }

    void fill(T value) {
        cells.fill(value);
    }

    void clear() {
        cells.clear();
        rowCount = 0;
        colCount = 0;
    }

    void free() {
        cells.free();
        rowCount = 0;
        colCount = 0;
    }
}
