use ariadne::{sources, Color, Label, Report, ReportKind};
use chumsky::error::Rich;
use chumsky::Parser;

mod lexer;

fn report_errors(filename: String, src: &str, errors: Vec<Rich<char>>) {
    errors.into_iter().map(|e| e.map_token(|c| c.to_string())).for_each(|e| {
        Report::build(ReportKind::Error, filename.clone(), e.span().start)
            .with_message(e.to_string())
            .with_label(
                Label::new((filename.clone(), e.span().into_range()))
                    .with_message(e.reason().to_string())
                    .with_color(Color::Red),
            )
            .with_labels(e.contexts().map(|(label, span)| {
                Label::new((filename.clone(), span.into_range()))
                    .with_message(format!("while parsing this {}", label))
                    .with_color(Color::Yellow)
            }))
            .finish()
            .print(sources([(filename.clone(), src)]))
            .unwrap()
    });
}

fn main() {
    let filename = "<src>";
    let src = "69.5";

    let (maybe_tokens, lexer_errors) = lexer::lexer().parse(src).into_output_errors();

    if let Some(tokens) = maybe_tokens {
        println!("tokens:");
        for (token, span) in tokens {
            println!("{}: {}", span, token);
        }
    }

    report_errors(filename.to_string(), src, lexer_errors);
}
