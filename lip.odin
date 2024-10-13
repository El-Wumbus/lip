package main

import "base:runtime"
import "core:flags"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:strings"

Flags :: struct {
	input:           os.Handle `usage:"Provide an input file, else stdin" args:"file=r"`,
	output:          os.Handle `usage:"Provide an output file, else stdout" args:"file=cw"`,
	log_level:       runtime.Logger_Level `usage:"How verbose the logging should be"`,
	begin:           string `usage:"Starting delimiter for code blocks" args:"required"`,
	end:             string `usage:"The ending delimiter for code blocks" args:"required"`,
	comment:         string `usage:"The programming language's prefix comment string" args:"required"`,
	select_code:     bool `usage:"Remove the surrounding text instead of commenting it out."`,
	avoid_ending_bs: bool `usage:"Remove trailing backslashes in commented text."`,
	case_sensitive:  bool `usage:"Case sensitively check begin/end delimiters"`,
}

map_input :: proc(
	input: ^string,
	opts: ^Flags,
) -> (
	output: string,
	error: mem.Allocator_Error = nil,
) {
	begin := strings.trim_space(opts.begin)
	end := strings.trim_space(opts.end)
	comment := strings.trim_space(opts.comment)
	select_code := opts.select_code
	avoid_end_bs := opts.avoid_ending_bs
	case_sensitive := opts.case_sensitive
	if !case_sensitive {
		begin = strings.to_lower(begin)
		end = strings.to_lower(end)
		comment = strings.to_lower(comment)
	}

	builder: strings.Builder
	strings.builder_init(&builder)
	defer strings.builder_destroy(&builder)

	code_section := false
	for line in strings.split_lines_iterator(input) {
		if code_section {
			if strings.trim_space(line) == end {
				if !select_code {
					fmt.sbprintfln(&builder, "%s %s", comment, line)
				} else {
					fmt.sbprint(&builder, "\n")
				}
				code_section = false
			} else {
				fmt.sbprintln(&builder, line)
			}
		} else {
			// C allows single-line comments to be extended by backslashes, the compiler may complain about this.
			if !select_code {
				if avoid_end_bs && strings.ends_with(strings.trim_right_space(line), "\\") {
					fmt.sbprintfln(&builder, "%s %s", comment, line[:len(line) - 1])
				} else {
					fmt.sbprintfln(&builder, "%s %s", comment, line)
				}
			}
			if strings.trim_space(line) == begin {
				code_section = true
			}
		}
	}
	output = strings.clone_from(strings.to_string(builder)) or_return
	return
}

main :: proc() {
	flgs: Flags
	flags.parse_or_exit(&flgs, os.args, .Unix)

	log_level := flgs.log_level if flgs.log_level != nil else .Debug
	input := flgs.input if flgs.input != os.INVALID_HANDLE else os.stdin
	output := flgs.output if flgs.output != os.INVALID_HANDLE else os.stdout

	// Log to stderr as to not taint any piped output
	context.logger = log.create_file_logger(
		os.stderr,
		lowest = log_level,
		opt = {.Level, .Terminal_Color},
	)

	data, err := os.read_entire_file_from_handle_or_err(input)
	if err != nil {
		fmt.eprintfln("Error reading INPUT: %v", err)
		os.exit(1)
	}
	text := string(data)

	out_text, terr := map_input(&text, &flgs)
	if terr != nil {
		fmt.eprintfln("Error: %s", err)
		os.exit(1)
	}

	fmt.fprint(output, out_text)
}
