import vim
import os, re

pushd_regex = re.compile('pushd\s+(.*)')
source_regex = re.compile('source\s+(.*)')

var_class = r'[-_\w\d\*]'

# finds all pushds and sets search path accordingly
def get_soar_file_abs_path(file):
	if not source_regex.match(vim.current.line):
		return None

	w = vim.current.window
	b = vim.current.buffer
	dir_stack = []
	prefix = vim.eval("expand('%:p:h')")

	for line in b[:w.cursor[0]]:
		m = pushd_regex.search(line)
		if m:
			dir_stack.append(m.groups()[0])
		elif line.strip() == "popd" and len(dir_stack) > 0:
			dir_stack.pop()
	#return os.path.join(os.path.join(prefix, os.sep.join(dir_stack)), file)
	vim.command('let b:return_value="%s"' % os.path.join(os.path.join(prefix, os.sep.join(dir_stack)), file))

#def open_soar_file_under_cursor():
#	f = get_soar_file_under_cursor()
#	if f:
#		vim.command('edit %s' % f)
#	else:
#		return 0

def chain_var():
	l = vim.current.line
	b = vim.current.buffer
	w = vim.current.window
	m = re.search(r'<(%s+)>\s*\+?\s*\)\s*' % var_class, l)
	if m == None:
		return

	curr_line_num = w.cursor[0]
	b[curr_line_num:curr_line_num] = ["(<%s> ^" % m.groups()[0]]
	vim.command('norm j==A')
