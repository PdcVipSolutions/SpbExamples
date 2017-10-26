/*****************************************************************************
Copyright (c) Elena Efimova

Translated by Victor Yukhtenko
******************************************************************************/
goal
    mainExe::run(main::run).


implement main
    open core, console

domains
    cell = c(unsigned16, unsigned16).
    cells = cell*.

class predicates
    wins: (positive, positive, cells, cells) nondeterm (i,i,i,o).
clauses
    wins(_Player1, _Player2, PolyLine, PolyLine1):-
        step(PolyLine, PolyLine1, Cell),
        list::isMember(Cell, PolyLine).
    wins(Player1, Player2, PolyLine, PolyLine1):-
        step(PolyLine, PolyLine1, _),
        not(wins(Player2, Player1, PolyLine1, _)).

class predicates
    move: (positive, cells).
clauses
    move(2, PolyLine):-
        step(PolyLine, PolyLine1, Cell),
        list::isMember(Cell, PolyLine),
        !,
        show(PolyLine1),
        setLocation(console_native::coord(0, 14)),
        write("Computer Won!\n\n", PolyLine1).
    move(2, PolyLine):-
        wins(2, 1, PolyLine, PolyLine1),
        !,
        move(1, PolyLine1).
    move(2, PolyLine):-
        step(PolyLine, PolyLine1, _),
        !,
        move(1, PolyLine1).
    move(1, PolyLine):-
        show(PolyLine),
        setLocation(console_native::coord(0, 14)),
        write(PolyLine),
        std::repeat(),
            write( "\n\nIt is your turn.\nEnter the new cell as c(2,3): "),
            hasDomain(cell, К),
            К = read(),
            clearInput(),
        step(PolyLine, PolyLine1, К),
        !,
        if list::isMember(К, PolyLine) then
            write("\nCongratulations! You have won!")
        else
            move(2, PolyLine1)
        end if.
    move(_, _).

class predicates
    step: (cells, cells, cell) nondeterm (i,o,o) (i,o,i).
clauses
    step([A, B | PolyLine], [X, A, B | PolyLine], X):-
        candidate(A, X),
        not(X = B).
    step(PolyLine, PolyLine1, X):-
        PolyLine2 = list::reverse(PolyLine),
        PolyLine2 = [A, B | _],
        candidate(A, X),
        not(X = B),
        PolyLine1 = list::append(PolyLine, [X]).

class predicates
    candidate: (cell, cell) nondeterm (i,o) (i,i).
clauses
    candidate(c(X, Y), c(X - 1, Y)):- X > 1.
    candidate(c(X, Y), c(X + 1, Y)):- X < 6.
    candidate(c(X, Y), c(X, Y - 1)):- Y > 1.
    candidate(c(X, Y), c(X, Y + 1)):- Y < 5.

class predicates
    show: (cells).
clauses
    show(PolyLine):-
        clearOutput(),
        foreach I = std::fromTo(1, 6) do
            setLocation(console_native::coord(3*I, 0)), write(I)
        end foreach,
        foreach J = std::fromTo(1, 5) do
            setLocation(console_native::coord(0, 2*J)), write(J)
        end foreach,
        foreach c(X, Y) = list::getMember_nd(PolyLine) do
            setLocation(console_native::coord(3*X, 2*Y)), write("*")
        end foreach.

clauses
    run():-
        init(),
        write("Wich player moves first? (1 - human, 2 - computer): "),
        Player = read(),
        clearInput(),
        if Player = 1 then
            write("Enter the start  of the line as  c(3,3): "),
            hasDomain(cell, К1),
            К1 = read(),
            clearInput(),
            write("Enter the end of the line: "),
            hasDomain(cell, К2),
            К2 = read(),
            clearInput(),
            move(2, [К1, К2])
        else
            move(1, [c(3, 3), c(4, 3)])
        end if,
        _ = readLine().

end implement main