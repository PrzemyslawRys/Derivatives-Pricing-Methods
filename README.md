# Derivatives pricing methods

The project contains the implementation of different methods for pricing of derivatives, such as plain vanilla, American or Asian options in Black-Scholes framework (all) and Heston square-root model (plain vanilla put). Some of them additionally return sensitivity analysis parameters, called Greeks, e.g. delta, gamma, theta. Please check the list of functionalities below:

- getEuropeanPutPriceByMonteCarloQuasiMonteCarlo: allow to price European plain vanilla put option using Monte Carlo and Quasi-Monte Carlo methodology. Quasi-Monte Carlo is based on Halton's low-discrepancy sequences instead of pseudo-random number generators. The analytical formula for considered option price is relatively easy to obtain from calculations, thus the main goal of this example is to analyze how simulations using low discrepancy sequences are more efficient than standard methods, based on standard uniform sampling implemented in R.

- getAmericanAndEuropeanCRRPriceAndGreeks: allows pricing American and European options in the Cox-Ross-Rubinstein binomial model. Additionally, function approximates Greeks. Let me remind, that the considered model converges to the Black-Scholes model when step size converges to 0, so it can be a good alternative, especially for American, path-dependent options.

- getAsianCallPriceWithControlVariables: allows to price Asian call options on arithmetic average using control variables variance reduction technique, based on a geometric average call option, which price can be calculated analytically. 

- example-getCapPowerCallPriceByPDE : allows to price cap power call options with payoff $max(Cap,(S_T^i-K))$ using partial differential equations approach and numerical schemes. The calculations are made for two cases - natural variables and variables transformed to heat equation coordinates.

The project contains all code required to reproduce the results of my research on Bayesian estimation of volatility and structural parameters of continuous GARCH model with Markov Chain Monte Carlo (MCMC) methods. The structure of the repository, e.g. extracting functionalities into different functions allows a user to easily calibrate the continuous GARCH model and estimate the volatility process for any time series. Additionally, functions simulating artificial data from considered models are included.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Please check the prerequisites below and make sure to install all packages and libraries before running the code.

- *fOptions* package for *runif.halton* function, generating Halton sequence, Quasi Monte Carlo method is based on.

### Input data structure

The input data structure is not required. Methods in this project are suited for derivatives pricing problem for predefined parameters. If you would like to use them for real financial assets, you should calibrate one of the available models (Black-Scholes, Heston) to market data. Calibrating methods are not part of this project.

### Examples of use

Please find examples in the main folder of the repository with prefix 'example'. All functionalities can be tested and used without external data.

## Authors

* **Przemysław Ryś** - [see Github](https://github.com/PrzemyslawRys), [see Linkedin](https://www.linkedin.com/in/przemyslawrys/)

Codes were prepared for the Computational Finance course on the Faculty of Mathematics, Informatics and Mechanics, University of Warsaw and they are based on lectures provided by prof. Andrzej Palczewski and dr. Piotr Kowalczyk.