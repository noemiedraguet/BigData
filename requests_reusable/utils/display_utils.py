import os
os.system('color')

def colorprint(mytext:str, terminalcolor:str = "green", verbose:bool = True, print_type:str = 'std') -> None:
    """
    Uses ANSI escape code color codes to render colored print statement in terminal.\n

    Parameters
    ----------
    `mytext` : text to render
    `terminalcolor` : color to render
    `verbose` : whether or not to print the text
    `print_type` : among `std` (default) : newline, `seq` : same line, `over`: overwrite line.\n
                if set to "seq", next print statement will be printed on the same line

    Return
    ------
    `return` : A pandas Dataframe containing the sharepoint file content
    """
    if not verbose:
        return
    colorend = '\033[0m'
    if terminalcolor == "green":
        colorstart = '\033[92m'
    elif terminalcolor == "red":
        colorstart = '\033[91m'
    elif terminalcolor == "blue":
        colorstart = '\033[94m'
    elif terminalcolor == "green_underline":
        colorstart = '\x1b[6;37;42m'
        colorend = '\x1b[0m'
    elif terminalcolor == "red_underline":
        colorstart = '\x1b[0;37;41m'
        colorend = '\x1b[0m'
    elif terminalcolor == "grey_underline":
        colorstart = '\x1b[0;30;47m'
        colorend = '\x1b[0m'
    elif terminalcolor == "light_blue":
        colorstart = '\033[36m'
    else:
        colorstart = '\033[93m'
    
    match print_type:
        case 'std' : print(colorstart + mytext + colorend)
        case 'seq' : print(colorstart + mytext + colorend, end = " ", flush= True)
        case 'over' : print(colorstart + mytext + colorend, end = '\r')