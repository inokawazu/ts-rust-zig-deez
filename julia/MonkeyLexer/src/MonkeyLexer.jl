module MonkeyLexer

@enum TokenType begin
    # Special
    Illegal
    EOF

    # Identifiers + literals
    Ident
    IntToken

    # Operators
    Assign
    Eq
    Neq
    Plus
    Minus
    Bang
    Asterisk
    Slash

    LT
    GT

    # Delimiters
    Comma
    Semicolon

    LParen
    RParen
    LBrace
    RBrace

    # Keywords
    FunctionToken
    Let
    True
    False
    If
    Else
    Return
end

struct Token
    type::TokenType
    literal::String

    function Token(type::TokenType, literal::Union{AbstractString, AbstractChar}) 
        return new(type, string(literal))
    end
end

Base.show(io::IO, t::Token) = print(io, "Token(", t.type, ", ", repr(t.literal), ")")

import Base: ==
==(a::Token, b::Token) = a.type == b.type && a.literal == b.literal

const KEYWORDS = Dict(
    "fn" => FunctionToken,
    "let" => Let,
    "true" => True,
    "false" => False,
    "if" => If,
    "else" => Else,
    "return" => Return
)

lookup_ident(ident::AbstractString) = get(KEYWORDS, ident, Ident)

mutable struct Lexer
    input::String
    position::Int
    read_position::Int
    ch::Char
end

function Lexer(input::String)
    all(isascii, input) || error("Non-ASCII characters are not supported.")

    l = Lexer(input, 0, 1, '\0')
    read_char!(l)
    return l
end

function read_char!(l::Lexer)
    l.ch = l.read_position > length(l.input) ? '\0' : l.input[l.read_position]
    l.position = l.read_position
    l.read_position += 1
    return
end

function peek_char(l::Lexer)
    return l.read_position > length(l.input) ? '\0' : l.input[l.read_position]
end

function skip_whitespace!(l::Lexer)
    while isspace(l.ch)
        read_char!(l)
    end
    return
end

is_monkey_letter(ch::AbstractChar) = isletter(ch) || ch == '_'

function read_identifier!(l::Lexer)
    position = l.position
    while is_monkey_letter(l.ch)
        read_char!(l)
    end
    return l.input[position:l.position-1]
end

function read_number!(l::Lexer)
    position = l.position
    while isdigit(l.ch)
        read_char!(l)
    end
    return l.input[position:l.position-1]
end

function next_token!(l::Lexer)
    skip_whitespace!(l)

    token = 
    if l.ch == '=' && peek_char(l) == '='
        ch = l.ch
        read_char!(l)
        Token(Eq, ch*l.ch)
    elseif l.ch == '=' && peek_char(l) != '='
        Token(Assign, l.ch)
    elseif l.ch == '!' && peek_char(l) == '='
        ch = l.ch
        read_char!(l)
        Token(Neq, ch*l.ch)
    elseif l.ch == '!' && peek_char(l) != '='
        Token(Bang, l.ch)
    elseif l.ch == '*'
        Token(Asterisk, l.ch)
    elseif l.ch == '/'
        Token(Slash, l.ch)
    elseif l.ch == '<'
        Token(LT, l.ch)
    elseif l.ch == '>'
        Token(GT, l.ch)
    elseif l.ch == '-'
        Token(Minus, l.ch)
    elseif l.ch == '+'
        Token(Plus, l.ch)
    elseif l.ch == '('
        Token(LParen, l.ch)
    elseif l.ch == ')'
        Token(RParen, l.ch)
    elseif l.ch == '{'
        Token(LBrace, l.ch)
    elseif l.ch == '}'
        Token(RBrace, l.ch)
    elseif l.ch == ','
        Token(Comma, l.ch)
    elseif l.ch == ';'
        Token(Semicolon, l.ch)
    elseif l.ch == '\0'
        Token(EOF, "")
    elseif is_monkey_letter(l.ch)
        literal = read_identifier!(l)
        type = lookup_ident(literal)
        return Token(type, literal)
    elseif isdigit(l.ch)
        literal = read_number!(l)
        type = IntToken
        return Token(type, literal)
    else
        Token(Illegal, l.ch)
    end

    read_char!(l)
    return token
end

export monkey_parse
function monkey_parse(input::AbstractString)
    l = Lexer(input)

    tokens = Token[]
    while true
        token = next_token!(l)
        push!(tokens, token)
        token.type == EOF && break
    end

    return tokens
end

test_code() = """let five = 5; let ten = 10; let add = fn(x, y) { x + y; }; let result = add(five, ten); !-/*5; 5 < 10 > 5; if (5 < 10) { return true; } else { return false; }"""

end # module MonkeyLexer
