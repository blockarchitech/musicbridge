// 
// Parse applescript multi-line string into osascript -e "..." commands
// 

import Foundation

func parseScript(_ script: String) -> [String] {
	var lines = [String]()
	var line = ""
	
	for c in script {
		if c == "\n" {
			lines.append(line)
			line = ""
		} else {
			line.append(c)
		}
	}

	if line != "" {
		lines.append(line)
	}

	return lines
}