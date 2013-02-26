fs = require 'fs'
exec = require('child_process').exec
path = require 'path'
srcDir = 'equations'
outDir = 'output'
makeTexDoc = (srcFileName) ->
    basename = path.basename(srcFileName, '.eq')
    eq = fs.readFileSync("#{srcDir}/#{srcFileName}")
    tex = """
\\documentclass[convert]{standalone}
\\usepackage{graphicx,amssymb}
\\begin{document}
\\ensuremath
$#{eq}$
\\end{document}
    """
    texDoc =  "#{outDir}/#{basename}.tex"
    fs.writeFileSync(texDoc, tex)
    basename

makeEq = (srcFileName) ->
    basename = makeTexDoc srcFileName
    cmd = "pdflatex -shell-escape -halt-on-error -interaction=nonstopmode  #{basename}.tex" # --jobname=#{texDoc.basename}
    console.log(cmd)
    exec cmd, cwd:outDir, (error, stdout, stderr) -> 
        if error
            console.log(stdout)
            console.error(stderr)
            console.error(error)
            throw error
        for ext in ['tex', 'log', 'aux', 'pdf']
            fs.unlink("#{outDir}/#{basename}.#{ext}")


for file in fs.readdirSync(srcDir) when file.match /\.eq/
    makeEq(file)