use std::fmt;

use chumsky::prelude::*;

pub type Span = SimpleSpan<usize>;

#[derive(Clone, Debug, PartialEq)]
pub enum Token<'src> {
    // TODO: this needs to be some sort of `BigInteger`
    Int(i64),

    Str(&'src str),
}

impl<'src> fmt::Display for Token<'src> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Token::Int(n) => write!(f, "{}", n),
            Token::Str(s) => write!(f, "'{}'", s),
        }
    }
}

pub fn lexer<'src>(
) -> impl Parser<'src, &'src str, Vec<(Token<'src>, Span)>, extra::Err<Rich<'src, char, Span>>> {
    let int = text::int(10).to_slice().from_str().unwrapped().map(Token::Int);

    let str_ = just('\'')
        .ignore_then(none_of('\'').repeated().to_slice())
        .then_ignore(just('\''))
        .map(Token::Str);

    let token = int.or(str_);

    let comment = just("--").then(any().and_is(just('\n').not()).repeated()).padded();

    token
        .map_with(|tok, e| (tok, e.span()))
        .padded_by(comment.repeated())
        .padded()
        // if we encounter an error, skip and attempt to lex the next character as a token instead
        .recover_with(skip_then_retry_until(any().ignored(), end()))
        .repeated()
        .collect()
}
