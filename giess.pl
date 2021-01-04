% GIESS - Galaxy Identification Expert System Shell

% SWI Prolog
% Cosc 4p79 Project (assignment 4)
% Mike Young - 4245718
% All example of output can be found in the ReadMe.txt

?- dynamic known/3.
?- dynamic tracing/1.
?- unknown(_, fail).

tracing(false).
 	

main :-
	greeting,
	repeat,
	write('$> '),
	read(X),
	do(X),
	X == quit.

greeting :-
	write('*************************'),nl,
	write('*** Welcome to GIESS! ***'),nl,
	write('*************************'),nl,nl,
	write('The expert system shell that allows the user to classify galaxies!.'), nl,nl,
	write('Start by typing one of the following commands at the prompt. Type help. for more information about each command.'),nl,
	write('To load your knowledge base right away, type [load.] without quotes at the prompt.'), nl,
	write('[help.] [dump.] [trace.] [load.] [solve.] [how(Goal).] [why.] [whynot(Goal)] [quit.]'),nl.

do(help) :- giess_help, !.
do(load) :- load_kb, write('Type [solve.] to start the inference engine'),!.
do(solve) :- solve, !.
do(dump(A)):- dump(A),!.
do(trace) :- (tracing(true),abolish(tracing/1),asserta(tracing(false)),write('Tracing is deeeeactived.'),nl;abolish(tracing/1),asserta(tracing(true)),write('Tracing has been activated.'),nl),!. 
do(how(Goal)) :- how(Goal), !.
do(whynot(Goal)) :- whynot(Goal), !.
do(quit):-!.
do(X) :-
	write(X),
	write(' is not a legal command. Type [help.] for more information on valid commands.'), nl,
	fail.

giess_help :-
	nl,
	write('*** Help ***'),nl,
	write('Type in any one of the following commands at the prompt in order to communicate with the expert system.'),nl,
	writeln('	[help.] - Displays the list of commands.'),
	writeln('	[dump(Goal).] - Dumps the current execution tree of the given Goal'),
	writeln('	[trace.] - Enables or disables tracing in the expert system chain of reasoning.'),
	writeln('	[load.] - Tells the expert system you wish to load a knowledge base. Afterwards you will be prompted for the knowledge base name'),
	writeln('	[solve.] - Starts the line of reasoning.'),
	writeln('	[how(Goal).]- Explains how a certain goal was solved.'),
	writeln('	[why.] - Explains why a certain goal was solved. Continuous querying results in hierarchical explanation of goals.'),
	writeln('	[whynot(Goal).] - Explains why a certain goal was not solved.'),
	writeln('	[quit.] - Quits and closes the expert system and the working knowledge base if there is one.'),
	write('************'),nl.

load_kb :-
	write('Enter file name in single quotes (ex. ''galaxy.nkb''.): '),
	read(F),
	my_consult(F).

dump(true):-!.
dump((Goal,Rest)):-
	!,
	write(' if '),write(Goal),write(' and '),nl,
	dump(Rest).
dump(Goal):-
	clause(Goal,Body),
	write(Goal),
	dump(Body),nl.

solve :-
	abolish(known/3),
	prove(top_goal(X),[]),
	write('The answer is '),write(X),write(' galaxy.'),nl.
solve :-
	write('No answer found.'),nl.
	
ask(Attribute,Value,_) :-
	known(yes,Attribute,Value),     % succeed if we know its true
	!.                              % and dont look any further
ask(Attribute,Value,_) :-
	known(_,Attribute,Value),       % fail if we know its false
	!, fail.

ask(Attribute,_,_) :-
	\+ multivalued(Attribute),
	known(yes,Attribute,_),         % fail if its some other value.
	!, fail.                        % the cut in clause #1 ensures
					% this is the wrong value
ask(A,V,Hist) :-
	write(A :V),                     % if we get here, we need to ask.
	write('? (yes or no) '),
	get_user(Y,Hist),
	asserta(known(Y,A,V)),          % remember it so we dont ask again.
	Y = yes.                        % succeed or fail based on answer.
	


% "menuask" is like ask, only it gives the user a menu to to choose
% from rather than a yes on no answer.  In this case there is no
% need to check for a negative since "menuask" ensures there will
% be some positive answer.

menuask(Attribute,Value,_,_) :-
	known(yes,Attribute,Value),     % succeed if we know
	!.
menuask(Attribute,_,_,_) :-
	known(yes,Attribute,_),         % fail if its some other value
	!, fail.

menuask(Attribute,AskValue,Menu,Hist) :-
	nl,write('What is the value for '),write(Attribute),write('?'),nl,
	display_menu(Menu),
	write('Enter the number of your choice> '),
	get_user(Num,Hist),nl,
	pick_menu(Num,AnswerValue,Menu),
	asserta(known(yes,Attribute,AnswerValue)),
	AskValue = AnswerValue.         % succeed or fail based on answer

display_menu(Menu) :-
	disp_menu(1,Menu), !.             % make sure we fail on backtracking

disp_menu(_,[]).
disp_menu(N,[Item | Rest]) :-            % recursively write the head of
	write(N),write('  : '),write(Item),nl, % the list and disp_menu the tail
	NN is N + 1,
	disp_menu(NN,Rest).

pick_menu(N,Val,Menu) :-
	integer(N),                     % make sure they gave a number
	pic_menu(1,N,Val,Menu), !.      % start at one
pick_menu(Val,Val,_).             % if they didn't enter a number, use
	                                % what they entered as the value

pic_menu(_,_,none_of_the_above,[]).  % if we've exhausted the list
pic_menu(N,N, Item, [Item|_]).       % the counter matches the number
pic_menu(Ctr,N, Val, [_|Rest]) :-
	NextCtr is Ctr + 1,                % try the next one
	pic_menu(NextCtr, N, Val, Rest).

get_user(X,Hist) :-
	repeat,
	write('$> '),
	read(X),
	process_ans(X,Hist), !.
	
process_ans(why,[_,Second|Rest]) :-
	write('Want to see if it\'s '),write(Second),nl, !, fail.
process_ans(X,_).	

% Prolog in Prolog for explanations.
% It is a bit confusing because of the ambiguous use of the comma, both
% to separate arguments and as an infix operator between the goals of
% a clause.

prove(true,_) :- !.
prove(menuask(X,Y,Z),Hist) :- menuask(X,Y,Z,Hist), !.
prove(ask(X,Y),Hist) :- ask(X,Y,Hist), !.
prove((Goal,Rest),Hist) :-
		!,
        prove(Goal,[Goal|Hist]),
        prove(Rest,Hist).
prove(Goal,Hist) :-
        clause(Goal,Body),
        prove(Body,Hist).

% Explanations
how(Goal) :-
	clause(Goal,Body),
	prove(Body,[]),
	write('Because the '),
	write_body(4,Body),
	write('it follows that '), write(Goal),tab2(4),nl.

whynot(Goal) :-
	clause(Goal,Body),
	write_line([Goal,'fails because: ']),
	explain(Body).
whynot(_).


explain(true).
explain((Head,Body)) :-
	!,
	check(Head),
	explain(Body).
explain(Goal) :-   		% new!
	check(Goal).

check(H) :- prove(H,[]), write_line([H,succeeds]), !.
check(H) :- write_line([H,fails]), fail.

write_list(N,[]).
write_list(N,[H|T]) :-
	tab2(N),write(H),nl,
	write_list(N,T).

write_body(N,(First,Rest)) :-
	write(First),nl,tab2(N),write('and the '),
	write_body(N,Rest).
write_body(N,Last) :-
	write(Last),nl.

write_line(L) :-
	flatten(L,LF),
	write_lin(LF).
	
write_lin([]) :- nl.
write_lin([H|T]) :-
	write(H), tab2(1),
	write_lin(T).

flatten([],[]) :- !.
flatten([[]|T],T2) :-
	flatten(T,T2), !.
flatten([[X|Y]|T], L) :-
	flatten([X|[Y|T]],L), !.
flatten([H|T],[H|T2]) :-
	flatten(T,T2).
                                                                    
my_consult(Files) :-
	load_files(Files, [load_type(source),compilation_mode(assert_all)]).
	% load_files('C:\\Users\\Mike\\Desktop\\Classes\\COSC 4P79\\Assignment 3\\Problem 2\\birds.nkb', [compilation_mode(assert_all)]).

tab2(N) :- N =< 0, !.
tab2(N) :-
	write(' '),
	M is N-1,
	!,
	tab2(M).



