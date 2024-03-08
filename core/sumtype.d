// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT

/// The sumtype module defines a data structure that can hold one of several possible types.
/// It provides functionalities to construct, access, and manipulate these values.

module popka.core.sumtype;

/// The none type.
struct None {}

/// A data structure that can hold one of several possible types.
/// Note that generic types are not currently supported.
struct SumType(A...) {
    template memberName(T) {
        mixin("enum memberName = \"" ~ ((T.stringof[0] >= 'A' && T.stringof[0] <= 'Z') ? cast(char) (T.stringof[0] + 32) : T.stringof[0]) ~ T.stringof[1 .. $] ~ "\";");
    }

    template dataName(T) {
        mixin("enum dataName = \"" ~ memberName!T ~ "Data\";");
    }

    template kindName(T) {
        mixin("enum kindName = \"" ~ memberName!T ~ "Kind\";");
    }

    union Data {
        static foreach (T; A) {
            mixin("T ", dataName!T, ";");
        }
    }

    alias Kind = ushort;
    static foreach (i, T; A) {
        mixin("enum ", kindName!T, " = ", i, ";");
    }

    Data data;
    Kind kind;
    alias data this;

    static foreach (i, T; A) {
        this(T data) {
            this.data = *(cast(Data*) &data);
            this.kind = i;
        }
    }

    static foreach (i, T; A) {
        void opAssign(T rhs) {
            data = *(cast(Data*) &rhs);
            kind = i;
        }
    }

    auto call(string f, AA...)(AA args) {
        final switch (kind) {
            static foreach (T; A) {
                mixin("case ", kindName!T, ": return ", dataName!T, ".", f ~ "(args);");
            }
        }
    }
}

alias Optional(T) = SumType!(None, T);

bool isNone(T)(T optional) {
    return optional.kind == optional.noneKind;
}

bool isSome(T)(T optional) {
    return optional.kind != optional.noneKind;
}

bool hasCommonBase(T)() {
    alias Base = typeof(T.init.data.tupleof[0]);

    static foreach (member; T.init.data.tupleof[1 .. $]) {
        static if (member.tupleof.length == 0) {
            return false;
        } else static if (!is(Base == typeof(member.tupleof[0]))) {
            return false;
        }
    }
    return true;
}

mixin template AddBase(T) {
    T base;
    alias base this;
}

unittest {
    auto optional = Optional!int();
    assert(optional.isNone);
    optional = 69;
    assert(optional.isSome);
    optional = None();
    assert(optional.isNone);
}
