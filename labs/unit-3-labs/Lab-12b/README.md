# Lab-12b: Estimating Single Index Models (SIMs) from Equity Price Data
The objective of `Lab-12b` is to familiarize students with estimating linear regression model parameters for an _overdetermined_ dataset (more observations than parameters).

### Background
A single index model describes the return of a firm’s stock in terms of a firm-specific return and the overall market return. Single index models are asset pricing models which measure the risk and the return of a stock relative to a risk-free alternative investment, e.g., [government treasury bonds](https://www.treasurydirect.gov/marketable-securities/treasury-bonds/). One of the simplest (yet still widely used) single index models was developed by [Sharpe, 1963](https://pubsonline.informs.org/doi/10.1287/mnsc.9.2.277). 

Let $R_{i}(t)$ and $R_{m}(t)$ denote the firm-specific and market excess returns for period $t$:

$$
R_{i}\left(t\right) = \log\left(\frac{P_{i,t}}{P_{i,t-1}}\right) - \bar{r}
$$

The market return is approximated by the return of [SPY](https://www.google.com/finance/quote/SPY:NYSEARCA?sa=X&ved=2ahUKEwid6emuq_L9AhXVVDUKHQxjCSMQ3ecFegQIIxAg), an exchange-traded fund designed to track the [S&P 500 stock market index](https://en.wikipedia.org/wiki/S&P_500). The quantity $P_{i,t}$ denotes the close price per share for firm $i$ (in the data set) at time $t$, and $\bar{r}$ denotes the risk-free daily rate (calculated for you). Further, let $\epsilon_{i}\left(t\right)$ denote a [stationary normally distributed random noise process](https://en.wikipedia.org/wiki/Normal_distribution) with mean zero and standard deviation 
$\sigma_{i}$ (need to estimate). 

Then, the single index model for the excess return of firm $i$ is given by:

$$
R_{i}\left(t\right) = \alpha_{i}+\beta_{i}R_{m}\left(t\right)+\epsilon_{i}\left(t\right)\qquad{t=1,2,\dots,T}
$$

where $\alpha_{i}$ and $\beta_{i}$ are (unknown) model parameters: 

* The parameter $\alpha_{i}$ describes the firm specific return not explained by the market; thus, $\alpha_{i}$ is the idiosyncratic return of firm $i$.
* The parameter $\beta_{i}$ measures the relationship between the excess return of firm $i$ and the excess return of the market; a large $\beta_{i}$ suggests the market returns (or losses) are _amplified_ for firm $i$, while a small $\beta_{i}$ suggests the market returns (or losses) are _damped_ for firm $i$.
* The parameter $\beta_{i}$ can also be interpreted as a measure of the relative risk of investing in a firm $i$ relative to the overall market. 