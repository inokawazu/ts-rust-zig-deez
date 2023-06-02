using Test
import MonkeyLexer as ML

function lexer_test(code_string, expected_tokens)
    tokens = ML.monkey_parse(code_string)

    @testset "Lexer test..." begin
        @testset "Individual Token Lexer Test For th $(i)-th token $(expected_token)" for 
            (token, (i, expected_token)) in zip(tokens, enumerate(expected_tokens))
            @test token == expected_token
        end

        @testset "Same Number of Tokens" begin
            @test length(tokens) == length(expected_tokens)
        end
    end

end

lexer_test(
    """let five = 5; let ten = 10; let add = fn(x, y) { x + y; }; let result = add(five, ten); !-/*5; 5 < 10 > 5; if (5 < 10) { return true; } else { return false; } 10 == 10; 10 != 9;""",
    [
     ML.Token(ML.Let, "let"),
     ML.Token(ML.Ident, "five"),
     ML.Token(ML.Assign, "="),
     ML.Token(ML.IntToken, "5"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.Let, "let"),
     ML.Token(ML.Ident, "ten"),
     ML.Token(ML.Assign, "="),
     ML.Token(ML.IntToken, "10"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.Let, "let"),
     ML.Token(ML.Ident, "add"),
     ML.Token(ML.Assign, "="),
     ML.Token(ML.FunctionToken, "fn"),
     ML.Token(ML.LParen, "("),
     ML.Token(ML.Ident, "x"),
     ML.Token(ML.Comma, ","),
     ML.Token(ML.Ident, "y"),
     ML.Token(ML.RParen, ")"),
     ML.Token(ML.LBrace, "{"),
     ML.Token(ML.Ident, "x"),
     ML.Token(ML.Plus, "+"),
     ML.Token(ML.Ident, "y"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.RBrace, "}"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.Let, "let"),
     ML.Token(ML.Ident, "result"),
     ML.Token(ML.Assign, "="),
     ML.Token(ML.Ident, "add"),
     ML.Token(ML.LParen, "("),
     ML.Token(ML.Ident, "five"),
     ML.Token(ML.Comma, ","),
     ML.Token(ML.Ident, "ten"),
     ML.Token(ML.RParen, ")"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.Bang, "!"),
     ML.Token(ML.Minus, "-"),
     ML.Token(ML.Slash, "/"),
     ML.Token(ML.Asterisk, "*"),
     ML.Token(ML.IntToken, "5"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.IntToken, "5"),
     ML.Token(ML.LT, "<"),
     ML.Token(ML.IntToken, "10"),
     ML.Token(ML.GT, ">"),
     ML.Token(ML.IntToken, "5"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.If, "if"),
     ML.Token(ML.LParen, "("),
     ML.Token(ML.IntToken, "5"),
     ML.Token(ML.LT, "<"),
     ML.Token(ML.IntToken, "10"),
     ML.Token(ML.RParen, ")"),
     ML.Token(ML.LBrace, "{"),
     ML.Token(ML.Return, "return"),
     ML.Token(ML.True, "true"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.RBrace, "}"),
     ML.Token(ML.Else, "else"),
     ML.Token(ML.LBrace, "{"),
     ML.Token(ML.Return, "return"),
     ML.Token(ML.False, "false"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.RBrace, "}"),
     ML.Token(ML.IntToken, "10"),
     ML.Token(ML.Eq, "=="),
     ML.Token(ML.IntToken, "10"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.IntToken, "10"),
     ML.Token(ML.Neq, "!="),
     ML.Token(ML.IntToken, "9"),
     ML.Token(ML.Semicolon, ";"),
     ML.Token(ML.EOF, ""),
    ]
   )
