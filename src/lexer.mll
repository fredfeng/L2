{
  open Parser

  exception SyntaxError of string
  let syntax_error char = raise (SyntaxError ("Unexpected character: " ^ char))
}

let white = [' ' '\t' '\n' '\r']+
let id = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']* 
       | "+" | "-" | "*" | "/" | "%" | "=" | "!=" | ">" | ">=" | "<" | "<=" | "&" | "|" | "~"

rule token = parse
       | white                 { token lexbuf } (* Eat whitespace. *)
       | "let"                 { LET }
       | "lambda"              { LAMBDA }
       | "forall"              { FORALL }
       | "->"                  { ARROW }
       | '{'                   { LCBRACKET }
       | '}'                   { RCBRACKET }
       | "#t"                  { BOOL true }
       | "#f"                  { BOOL false }
       | '('                   { LPAREN }
       | ')'                   { RPAREN }
       | '['                   { LBRACKET }
       | ']'                   { RBRACKET }
       | ','                   { COMMA }
       | id as text            { ID text }
       | '-'?['0'-'9']+ as num { NUM (int_of_string num) }
       | eof                   { EOF }
       | _                     { syntax_error (Lexing.lexeme lexbuf) }
