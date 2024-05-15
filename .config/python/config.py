# NOTE: care has been taken to use code universally runnable under any
#       Python version and to delete any names bound as otherwise they
#       leak into the global namespace of the running REPL loop

# prevent startup recursion
import os
os.environ['PYTHONSTARTUP'] = ''
del os

start_python = None
try:
    from ptpython.repl import embed
    start_python = lambda: embed(globals(), locals())
except ImportError:
    try:
        from bpython import embed
        start_python = lambda: embed()
    except ImportError:
        try:
            from IPython import start_ipython
            start_python = lambda: start_ipython()
        except ImportError:
            pass
if start_python:
    raise SystemExit(start_python())

# if we're still here there is no custom REPL installed,
# continue on and use the built-in REPL
del start_python
import sys, warnings
try:
    class CustomHook:
        def __call__(self):
            self.register_readline()
            self.set_prompts()

        def register_readline(self):
            # largely copied from site.py which does not provide the
            # ability to customize defaults
            import atexit, os, sys
            try:
                import readline, rlcompleter
            except ImportError:
                warnings.warn('readline not avalible.', ImportWarning, stacklevel=2)
                return
            try:
                readline.read_init_file()
            except OSError:
                pass
            if readline.get_current_history_length() == 0:
                history_dir = os.path.expanduser(os.path.join('~', '.local', 'share', 'python'))
                history_file = '.python%s%s_history' % sys.version_info[:2]
                if not os.path.exists(os.path.dirname(history_dir)):
                    history_dir = os.path.expanduser('~')
                elif not os.path.exists(history_dir):
                    os.mkdir(history_dir)
                history = os.path.join(history_dir, history_file)
                try:
                    readline.read_history_file(history)
                except OSError:
                    pass
                def write_history():
                    try:
                        readline.write_history_file(history)
                    except OSError:
                        pass
                atexit.register(write_history)

        def set_prompts(self):
            from collections import namedtuple
            from datetime import datetime
            from bdb import Breakpoint
            from inspect import formatannotation
            from os import get_terminal_size
            from os.path import basename, dirname
            from pprint import pformat, pprint
            from sys import __displayhook__, __excepthook__, stdout
            import builtins
            import sys
            try:
                from termcolor import colored
            except ImportError:
                colored = lambda f, c: f
            Field = namedtuple('Field', ('field', 'term_len', 'color'))
            class SetPS1:
                SCROLLSTOP = 50
                last_result = Field('', 0, 'white')

                def __init__(self):
                    if sys.prefix != sys.base_prefix:
                        # we are in a virtualenv, try to get a name that makes
                        venv = basename(sys.prefix)
                        if venv.startswith('.') or venv in ('env', 'venv'):
                            venv = basename(dirname(sys.prefix))
                        venv = venv + '@'
                    else:
                        venv = ''
                    py_info = '{venv}{ver.major}.{ver.minor}.{ver.micro} '.format(venv=venv, ver=sys.version_info)
                    self.python_info = Field(py_info, len(py_info), 'green')

                def __displayhook__(self, value):
                    builtins._ = None
                    last_result = formatannotation(type(value))
                    self.last_result = Field(last_result, len(last_result), 'cyan')
                    # [pseudo-code of original __displayhook__](https://docs.python.org/3/library/sys.html#sys.displayhook)
                    if value is None:
                        return
                    text = pformat(value, compact=True)
                    nl = -1
                    for _i in range(self.SCROLLSTOP):
                        nl = text.find('\n', nl+1)
                        if nl == -1:
                            break
                    else:
                        text = text[:nl] + '\n ...'
                    text += '\n'
                    try:
                        stdout.write(text)
                    except UnicodeEncodeError:
                        btext = text.encode(stdout.encoding, 'backslashreplace')
                        if hasattr(stdout, 'buffer'):
                            stdout.buffer.write(btext)
                        else:
                            text = btext.decode(stdout.endocing, 'strict')
                            stdout.write(text)
                    builtins._ = value

                def __excepthook__(self, *args, **kwargs):
                    last_result = formatannotation(args[0])
                    self.last_result = Field(last_result, len(last_result), 'magenta')
                    __excepthook__(*args, **kwargs)

                @staticmethod
                def gather_bps():
                    # don't put in sys.breakpointhook as breakpoints
                    # can be set and cleared many ways
                    breakpoints = ''
                    for info, bps in Breakpoint.bplist.items():
                        if any((bp.enabled for bp in bps)):
                            breakpoints += '|{file}:{line}'.format(file=info[0], line=info[1])
                    if breakpoints:
                        breakpoints = ' 🔴 ' + breakpoints
                    return breakpoints

                @staticmethod
                def color(fields):
                    colored_fields = {}
                    for f, field in fields.items():
                        colored_fields[f] = colored(field.field, field.color)
                    return colored_fields

                def __str__(self):
                    try:
                        breakpoints = self.gather_bps()
                        time = datetime.utcnow().strftime('%H:%M:%S.%f')
                        fields = {
                            'last_result': self.last_result,
                            'breakpoints': Field(breakpoints, len(breakpoints), 'red'),
                            'python_info': self.python_info,
                            'time': Field(time, len(time), 'blue'),
                        }
                        final_fields = self.color(fields)
                        final_fields['padding'] = sum((-fields[x].term_len for x in fields if x != 'time'), start=get_terminal_size().columns)
                        # clear the last result for next line
                        self.last_result = Field('<STMT>', 6, 'white')
                        return '{last_result}{breakpoints}{python_info:>{padding}}{time}\n '.format(**final_fields)
                    except Exception:
                        # if PS fails, don't lock up the REPL
                        return '\n'
            class SetPS2:
                def __str__(self):
                    return '~'
            sys.ps1 = SetPS1()
            sys.ps2 = SetPS2()
            sys.displayhook = sys.ps1.__displayhook__
            sys.excepthook = sys.ps1.__excepthook__

    sys.__interactivehook__ = CustomHook()
    del CustomHook
except Exception:
    # something went very wrong, but attempt to move forward to allow debugging
    warnings.warn('Not able to load any customizations, attempting to start python',
                  RuntimeWarning, stacklevel=2)
finally:
    del sys, warnings

# The following will alter the REPL environment
from pprint import pprint as print
