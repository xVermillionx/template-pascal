UNIT CharList;

interface

  TYPE
    CharNodePtr = ^CharNode;
    CharNode = RECORD
      next: CharNodePtr;
      ch: CHAR;
    END; (* CharNode *)
    CharListPtr = CharNodePtr;


FUNCTION NewCharList: CharListPtr;
(* returns empty CharList *)
PROCEDURE DisposeCharList(VAR cl: CharListPtr);
(* disposes all nodes and sets cl to empty CharList *)
FUNCTION CLLength(cl: CharListPtr): INTEGER;
(* returns the number of characters in cl *)
FUNCTION CLConcat(cl1, cl2: CharListPtr): CharListPtr;
(* returns concatenation of cl1 and cl2 by copying the nodes of both lists *)
FUNCTION CharListOf(s: STRING): CharListPtr;
(* returns CharList representation of STRING *)
FUNCTION StringOf(cl: CharListPtr): STRING;
(* returns STRING representation of CharList, may result in truncatation *)


implementation


FUNCTION NewCharList: CharListPtr;
BEGIN
  NewCharList := NIL;
END;

PROCEDURE DisposeCharList(VAR cl: CharListPtr);
VAR
  head, temp: CharListPtr;
BEGIN
  head := cl;
  WHILE cl <> NIL DO
    BEGIN
      temp := cl^.next;
      Dispose(cl);
      cl := temp;
    END;
  cl := head;
END;

FUNCTION CLLength(cl: CharListPtr):INTEGER;
VAR
  ret : INTEGER;
  trav : CharListPtr;
BEGIN
  ret := 0;
  trav := cl;
  WHILE trav <> NIL DO
    BEGIN
      ret := ret + 1;
      trav := trav^.next;
    END;
    CLLength := ret;
END;

FUNCTION CLConcat(cl1, cl2: CharListPtr):CharListPtr;
VAR
  trav, ret, n, temp : CharListPtr;
  compare : BOOLEAN;
BEGIN
  ret := NIL;
  n := NIL;
  temp := NIL;

  WHILE (cl1 <> NIL) OR (cl2 <> NIL) DO
    BEGIN
      // Check what CharList to traverse
      compare := cl1 <> NIL;
      IF compare THEN
          trav := cl1
      ELSE
          trav := cl2;

      // Create Copy Node
      n := New(CharListPtr);
      n^.next := NIL;
      n^.ch := trav^.ch;
      IF temp = NIL THEN
        ret := n;

      // WriteLn(StringOf(n)); // DEBUG

      // Set next node of prev node
      IF temp <> NIL THEN
        temp^.next := n;
      temp := n;

      // Traverse
      IF compare THEN
          cl1 := cl1^.next
      ELSE
          cl2 := cl2^.next;
    END;

    CLConcat := ret;
END;

FUNCTION CharListOf(s: STRING):CharListPtr;
VAR
  i : INTEGER;
  ret : CharListPtr;
  node : CharListPtr;
  prev : CharListPtr;
BEGIN
  ret := NIL;
  prev := NIL;
  FOR i := 1 TO Length(s) DO
    BEGIN
      node := New(CharListPtr);
      node^.next := NIL;
      node^.ch := s[i];
      IF prev = NIL then
        BEGIN
          prev := node;
          ret := node;
        END
      ELSE
        BEGIN
          prev^.next := node;
          prev := node;
        END;
    END;

  CharListOf := ret;
END;

FUNCTION StringOf(cl: CharListPtr):STRING;
VAR
  ret : STRING;
  trav : CharListPtr;
BEGIN
  ret := '';
  trav := cl;
  WHILE trav <> NIL DO
    BEGIN
      ret := ret + trav^.ch;
      trav := trav^.next;
    END;
    StringOf := ret;
END;

// Works but can not create CharList longer than a STRING
FUNCTION CLSimpleConcat(cl1, cl2: CharListPtr):CharListPtr;
VAR
  s1, s2 : STRING;
BEGIN
  s1 := StringOf(cl1);
  s2 := StringOf(cl2);
  s1 := s1 + s2;
  CLSimpleConcat := CharListOf(s1);
END;

END.
