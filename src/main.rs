use std::io::Read;
use std::io::BufRead;
use std::iter::Iterator;
use itertools::{Itertools, Position};

fn main() {
    let mut file = std::fs::File::open(&std::env::args().nth(1).expect("ihex file")).unwrap();
    let mut buffer = Vec::<_>::new();
    file.read_to_end(&mut buffer).unwrap();
    let mut byte_counter = 0;
    for pos_line in buffer.lines().enumerate().with_position() {
        match pos_line {
            Position::First((_, line_res)) | Position::Middle((_, line_res)) => {
                let line = line_res.unwrap();
                let mut line_vec;
                line_vec = line.as_bytes().to_vec();
                //println!("{}", line);
                //popping checksum 
                line_vec.pop();
                line_vec.pop();
                //remove prepending shit
                for _ in 0..9 {
                    line_vec.remove(0);
                }
                for x in line_vec {
                    print!("{}",x as char);
                    byte_counter += 1;
                    if byte_counter % 2 == 0 {
                        print!(" ");
                    }
                    if byte_counter % 8 == 0 {
                        println!("");
                    }
                }
            },
            Position::Last(_) => (),
            //there can't be only one line
            _ => ()
        }
    }
}
