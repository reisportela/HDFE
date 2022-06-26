# HDFE

Show the repository on GitHub: [https://github.com/reisportela/HDFE](https://github.com/reisportela/HDFE)

## 1. Use [MyBinder](https://mybinder.org/) to run a container with R & RStudio + Julia

Launch MyBinder with RStudio

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/HDFE/HEAD?urlpath=rstudio)

## 2. Explore `fixest` in RStudio ecosystem

## 3. Open Visual Studio Code (locally)

> Run the Julia script `HDFE_Julia_script.jl`

## 4. Run Jupyter Lab (locally)

> and run the Julia notebook `HDFE_Julia_script.ipynb`

## 5. Use MyBinder to run the Julia Notebook

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/HDFE/HEAD?labpath=HDFE_Julia.ipynb)

## 6. Discuss the SoS notebook: computation time using Python, R, Julia and Stata (PRJS)

> Windows server: run the notebook `All_In_One_Python_R_Julia_Stata_FULL.ipynb`

> Python is too slow: run in the sample using the notebook `HDFE_Python.ipynb` using VSCode

### The data

LEED sample: 19,747,353 observations; 3,747,353 workers; 472,880 firms; 10 years (yearly data).

<img src="the_Data_Benchmark.png" width="400">


### The machine

Dell server with 48 Cores & 512 GB RAM running Windows Server 2019.

<img src="The_Machine.png" width="400">


### R: the state of the art

The fastest solution with an awesome ecosystem: 383.33 seconds (6.4 minutes).

![](R_performance.png)

### Julia: fast but lacks an adequate ecosystem

Not bad: 962.9 seconds (16.1 minutes)

<img src="Julia_performance_V2.png" width="1300">


### Stata: not a match for R or Julia, as far as computation time is concerned

Too slow: 5098.11 seconds (84 minutes).

![](Stata_performance.png)

### Python: just a concept

Forget it: still running.

![](Python_performance_V3.png)


<!--- 
## MyBinder::Just Jupyter notebook

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/HDFE/HEAD)


### Notes

[https://mybinder.readthedocs.io/en/latest/using/config_files.html#start-run-code-before-the-user-sessions-starts](https://mybinder.readthedocs.io/en/latest/using/config_files.html#start-run-code-before-the-user-sessions-starts)

[https://discourse.jupyter.org/t/glibcxx-3-4-26-not-found-from-rstudio/7778/4](https://discourse.jupyter.org/t/glibcxx-3-4-26-not-found-from-rstudio/7778/4)
-->
