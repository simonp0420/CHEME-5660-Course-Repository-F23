## CHEME-5660 Course Repository 
This repository holds the examples, the problem sets, and labs for CHEME 5660: Financial Data, Markets, and Mayhem for Fall 2023. 
The [online notes are available here](https://varnerlab.github.io/CHEME-5660-Markets-Mayhem-Book/infrastructure.html), and the [lecture slides for the Fall 2023 can be found here](https://cornell.box.com/s/7j6t9bip0u0xl0030ifhgn2v0e2yd7d5).

### Installation and Requirements

#### Installing Julia and Pluto
The examples used in the lecture and referenced from the book and the labs are written using the [Jupyter notebooks](https://jupyter.org) and the [Julia programming language](https://julialang.org). [Julia](https://julialang.org) is open source, accessible, and runs on all major operating systems and platforms. 

1. [Install Julia (we are using v1.8.x, but future versions of Julia should also work)](https://julialang.org/downloads/)
1. [Install Jupyter Notebooks via Anaconda](https://www.anaconda.com/)

For the labs, we use [Julia](https://julialang.org) as our Jupyter notebook kernel; this requires the installation of the [IJulia](https://github.com/JuliaLang/IJulia.jl) package. 

To install [IJulia](https://github.com/JuliaLang/IJulia.jl) from the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/) press the `]` key to enter [pkg mode](https://pkgdocs.julialang.org/v1/repl/) and the issue the command:

```
add IJulia
```

This will install the [IJulia](https://github.com/JuliaLang/IJulia.jl) package. Suppose you already have Python/Jupyter installed on your machine. In that case, this process will also install a [kernel specification](https://jupyter-client.readthedocs.io/en/latest/kernels.html#kernelspecs) that tells [Jupyter](https://jupyter.org) how to launch [Julia](https://julialang.org) so we can use it in the notebook. You can then launch the [Jupyter Notebook](https://jupyter.org) server the usual way by running `jupyter notebook` in the terminal.

### Disclaimer and Risks
This content is offered solely for training and informational purposes. No offer or solicitation to buy or sell securities or derivative products, or any investment or trading advice or strategy,  is made, given, or endorsed by the teaching team. 

Trading involves risk. Carefully review your financial situation before investing in securities, futures contracts, options, or commodity interests. Past performance, whether actual or indicated by historical tests of strategies, is no guarantee of future performance or success. Trading is generally inappropriate for someone with limited resources, investment or trading experience, or a low-risk tolerance.  Only risk capital that is not required for living expenses.

You are fully responsible for any investment or trading decisions you make. Such decisions should be based solely on evaluating your financial circumstances, investment or trading objectives, risk tolerance, and liquidity needs.
