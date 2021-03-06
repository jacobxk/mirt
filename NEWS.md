# Changes in mirt 1.3

## MAJOR CHANGES

- scores.only option now set to `TRUE` in `fscores()`

## NEW FEATURES

- `mirt.model()` syntax supports multiple * combinations in `COV = ` for more easily specifying 
  covariation blocks between factors. Also allows variances to be freed by specifying the same
  factor name, e.g., `F*F`

- `full.scores.SE` logical option for `fscores()` to return standard errors for each respondent

- multiple imputation (MI) option in `fscores()`, useful for obtaining less biased factor score 
  estimates when model parameter variability is large (usually due to smaller sample size)

- group-level (i.e., means/covariances) equality constrains are now available for 
  the EM algorithm

- `theta_lim` input to `plot()`, `itemplot()`, and `fscores()` for modifying range of 
  latent values evaluated

## BUG FIXES

- fix crash in two-tier models when correlations are estimated (reported by David Wu)

# Changes in mirt 1.2.1

## MAJOR CHANGES

- `fitIndices()` replaced with `M2()` function, and currently limited to only dichotomous items
  of class 'dich'

- `bfactor()` default SE.type set to 'crossprod' rather than 'SEM'

- generalized partial credit models now display fixed scoring coefs

- `TOL` convergence criteria moved outside of the `technical` input to its own argument

- `restype` argument to `residuals()` changed to `type` to be more consistent with the package

- removed `fitted()` since `residuals(model, type = 'exp')` gives essentially the same output

- mixedmirt has `SE` set to `TRUE` by default to help construct a more accurate information matrix

- if not specified, S-EM `TOL` dropped to `1e-6` in the EM, and `SEtol = .001` for each
  parameter to better approximate the information matrix

## NEW FEATURES

- two new `SE.type` inputs: 'Louis' and 'sandwich' for computing Louis' 1982 computation of
  the observed information matrix, and for the sandwich estimate of the covariance matrix

- `as.data.frame` logical option for `coef()` to convert list to a row-stacked data.frame

- `type = 'scorecontour'` added to `plot()` for a contour plot with the expected total scores

- `type = 'infotrace'` added to `itemplot()` to plot trace lines and information on the same plot,
  and `type = 'tracecontour'` for a contour plot using trace lines (suggested by Armi Lantano)

- `mirt.model()` support for multi-line inputs

- new `type = 'LDG2'` input for `residuals()` to compute local dependence stat based on G2
  instead of X2, and `type = 'Q3'` added as well

- S-EM computation of the information matrix support for latent parameters, which previously
  was only effective when estimation item-level parameters. A technical option has also been
  added to force the information matrix to be symmetric (default is set to `TRUE` for better
  numerical stability)

- new `empirical.CI` argument in `itemfit()` used when plotting confidence intervals for
  dichotomous items (suggested by Okan Bulut)

- `printSE` argument can now be passed to `coef()` for printing the standard errors instead of
  confidence intervals. As a consequence, `rawug` is automatically set to `TRUE` (suggested
  by Olivia Bertelli)

- second-order test and condition number added to estimated objects when an information
  matrix is computed

- `tables` argument can be passed to `residuals()` to return all observed and expected tables
  used in computing the LD statistics

## BUG FIXES

- using `scores.only = TRUE` for multipleGroup objects returns the correct person ordering
  (reported by Mateusz Zoltak)

- `read.mirt()` crash fix for multiple group analyses objects (reported by Felix Hansen)

- updated math for `SE.type = 'crossprod'`

- bias correction for standard errors in models that include equality constraints

# Changes in mirt 1.1

## NEW FEATURES

- `facet_items` argument added to plot() to control whether seperate plots should be constructed
  for each item or to merge them onto a single plot

- three dimensional models supported in `itemplot()` for types `trace`, `score`, `info`, and `SE`

- new DIF() function to quicky calculate common differential item functioning routines, similar
  to how IRTLRDIF worked. Supports likelihood ratio testings as well as the Wald approach, and includes
  forward and backword sequential DIF searching methods

- added a `shiny = TRUE` option to `itemplot()` to run the interactive shiny applet.
  Useful for instructive purposes, as well as understanding how the internal parameters of mirt behave

- `type = 'trace'` and `type = 'infotrace'` support added to `plot` generic for multiple group objects

- `fscores(..., method = 'EAPsum')` returns observed and expected values, along with general fit
  statistics that are printed to the console and returned as a 'fit' attribute

- removed multinomial constant in log-likelihood since it has no influence on nested model comparisons

- `SE.type = 'crossprod'` and `Fisher` added for computing the parameter information matrix based on the
  variance of the Fisher scoring vector and complete Fisher information matrix, respectively

- `customPriorFun` input to technical list now available for utilizing user defined prior distribution
  functions in the EM algorithm

- empirical histogram estimation now available in `mirt()` and `multipleGroup()` for unidimensional
  models. Additional plot `type = 'empiricalhist'` also added to the `plot()` generic

- reimplement `read.mirt()` with better consistency checking between the `plink` package

## BUG FIXES

- starting values for `multipleGroup()` now returns proper estimated parameter information from
  the `invariance` input argument

- remove `as.integer()` in MultipleGroup df slot

- pass proper item type when using custom pattern calles in `fscores()`

- return proper object in personfit when gpcm models used

# Changes in mirt 1.0

## NEW FEATURES

- `GenRandomPars` logical argument now supported in the `technical = list()` input. This will generate
  random starting values for freely estimated parameters, and can be helpful to determine if obtained
  solutions are local minimums

- seperate `free_var` and `free_cov` invariance options available in multipleGroup

- new `CONSTRAIN` and `CONSTRAINB` arguments in `mirt.model()` syntax for specifying equality
  constraints explicitly for parameters accross items and groups. Also the `PRIOR = ...`
  specification was brought back and uses a similar format as the new CONSTRAIN options

- `plot(..., type = 'trace')` now supports polytomous and dichotomous tracelines, and `type = 'infotrace'`
  has a better y-axis range

- removed the '1PL' itemtype since the name was too ambiguous. Still possible to obtain however by
  applying slope constraints to the 2PL/graded response models

- `plot()` contains a which.items argument to specify which items to plot in aggregate type, such as
  `'infotrace'` and `'trace'`

- `fitIndicies()` will return `CFI.M2` and `TLI.M2` if the argument `calcNull = TRUE` is passed. CFI stats also
  normed to fall between 0 and 1

- data.frame returned from `mod2values()` and `pars = 'values'` now contains a column indicating
  the internal item class

- use `ginv()` from MASS package to improve accuracy in `fitIndices()` calculation of M2

## BUG FIXES

- fix error thrown in `PLCI.mirt` when parameter value is equal to the bound

- fix the global df values, and restrict G2 statistic when tables are too sparse

# Changes in mirt 0.9.0

## NEW FEATURES

- `PLCI.mirt()` function added for computing profiled likelihood standard errors. Currently only applicable
  to unidimensional models

- prior distributions returned in the `pars = 'values'` data.frame along with the input parameters,
  and can be edited and returned as well

- full.scores option for `residuals()` to compute residuals for each row in the original data

- `bfactor()` can include an additional model argument for modeling two-tier structures introduced
  by Cai (2010), and now supports a `'group'` input for multiple group analyses

- added a general Ramsey (1975) acceleration to EM estimation by default. Can be disable with
  `accelerate = FALSE` (and is done so automatically when estimating SEM standard errors)

- renamed response.vector to response.pattern in `fscores()`, and now supports matrix input for
  computing factor scores on larger data sets (suggested by Felix Hansen)

- total.info logical added to `iteminfo()` to return either total item information or information
  from each category

- `mirt.model()` supports the so-called Q-matrix input format, along with a matrix input for the
  covariance terms

- MH-RM algorithm now accessible by passing `mirt(..., method = 'MHRM')`, and `confmirt()` function
  removed completely. `confmirt.model()` also renamed to `mirt.model()`

- support for polynomial and interaction terms in EM estimation

- lognormal priors may now be passed to parprior

- iterative computations in `fscores()` can now be run in parallel automatically following a
  `mirtCluster()` definition

- `mirtCluster()` function added to make utilizing parallel cores more convenient. Globally removed
  the cl argument for multi-core objects

- updated documentation for data sets by adding relevant examples, and added Bock1997 data set
  for replicating table 3 in van der Linden, W. J. & Hambleton, R. K. (1997)
  Handbook of modern item response theory

- general speed improvements in all functions

## BUG FIXES

- WLE estimation fixed and now estimates extreme response patterns

- exploratory starting values no longer crash in datasets with a huge number of NAs, which caused
  standard deviations to be zero

- math fix for beta priors

# Changes in mirt 0.8.0

## NEW FEATURES

- support for random effect predictors now available in `mixedmirt()`, along with a `randef()` function
  for computing MAP predictions for the random parameters

- EAPsum support in `fscores()` for mixed item types

- for consistency with current IRT software (rather than TESTFACT and POLYFACT), the scaling
  constant has been set to D = 1 and fixed at this value

- nominal.highlow option added to specify which categories are the highest and lowest in nominal models.
  Often provide better numerical stability when utilized. Default is still to use the highest and lowest
  categories

- increase number of draws in the Monte Carlo calculation of the log-likelihood from 3000 to 5000

- when itemtype all equal 'Rasch' or 'rsm' models the latent variance parameter(s) are automatically
  freed and estimated

- `mixedmirt()` more supportive of user defined R formulas, and now includes an internal 'items'
  argument to create the item design matrix used to estimate the intercepts. More closely mirrors
  the results from lme4 for Rasch models as well (special thanks to Kevin Joldersma for
  testing and debugging)

- `drop.zeros` option added to extract.item and itemplot to reduce dimensionality of factor structures
  that contain slopes equal to zero

- EM tolerance (TOL argument) default dropped to .0001 (originally .001)

- `type = 'score'` and `type = 'infoSE'` added to `plot()` generic for expected total score and joint test
  standard error/information

- custom latent mean and covariance matrix can be passed to `fscores()` for EAP, MAP, and EAPsum methods.
  Also applies to `personfit()` and `itemfit()` diagnostics

- scores.only option to `fscores()` for returning just the estimated factor scores

- bfactor can include NA values in the model to omit the estimation of specific factors for the
  corresponding item

## BUG FIXES

- limiting values in z.outfit and z.infit statistics for small sample sizes (fix suggested by Mike Linacre)

- missing data gradient bug fix in MH-RM for dichotomous item models

- global df fix for multidimensional confirmatory models

- SEM information matrix computed with more accuracy (M-step was not identical to original EM),
  and fixed when equality constrains are imposed

# Changes in mirt 0.7.0

## NEW FEATURES

- new `'#PLNRM'` models to fit Suh & Bolt (2010) nested logistic models

- `'large'` option added to estimation functions. Useful when the datasets being analysed are very
  large and organizing the data becomes a computationally burdensome task that should be avoided when
  fitting new models. Also, overall faster handling of datasets

- `plot()`, `fitted()`, and `residuals()` generic support added for MultipleGroup objects

- CFI and X2 model statistics added, and output now includes fit stats w.r.t. both G2 and X2

- z stats added for itemfit/personfit infit and outfit statistics

- supplemented EM ('SEM') added for calculating information matrix from EM history. By default
  the TOL value is dropped to help make the EM iterations longer and more stable. Supports
  parallel computing

- added return empirical reliability (`returnER`) option to `fscores()`

- `plot()` supports individual item information trace lines on the same graph (dichotomous items only) with
  the option `type = 'infotrace'`

- `createItem()` function available for defining item types that can be passed to estimation functions.
  This can be used to model items not available in the package (or anywhere for that matter) with the
  EM or MHRM. Derivatives are computed numerically by default using the numDeriv package for defining
  item types on the fly

- Mstep in EM moved to quasi-Newton instead of my home grown MV Newton-Raphson approach. Gives
  more stability during estimation when the Hessian is ill-conditioned, and will provide an easier
  front-end for defining user rolled IRT models

## BUG FIXES

- small bias fix in Hessian and gradients in `mirt()` implementation causing the likelihood to not always be
  increasing near maximum

- fix input to `itemplot()` when object is a list of model objects

- fixed implementation of infit and outfit Rasch statistics

- order of nominal category intercepts were sometimes backwards. Fixed now

- S_X2 collapsed cells too much and caused negative df

- `response.vector` input now supports NA inputs (reported by Neil Rubens)

# Changes in mirt 0.6.0

## NEW FEATURES

- S-X2 statistic computed automatically for unidimensional models via itemfit()

- EAP for sum-scores added to fscores() with method = 'EAPsum'. Works with full.scores option
  as well

- improve speed of estimation in multipleGroup() when latent means/variances are estimated

- multipleGroup(invariance = '') can include item names to specify which items are to
  be considered invariant accross groups. Useful for anchoring and DIF testing

- type = 'trace' option added to plot() to display all item trace lines on a single
  graph (dichotomous items only)

- default estimation method in multipleGroup() switched to 'EM'

- boot.mirt() function added for computing bootstrapped standard errors with via the boot
  package (which supports parallel computing as well), as well as a new option SE.type = ''
  for choosing between Bock and Lieberman or MHRM type information matrix computations

- indexing items in itemplot, itemfit, and extract.item can be called using either a number or the
  original item name

- added probtrace() function for front end users to generate probability trace functions from models

- plotting item tracelines with only two categories now omits the lowest
  category (as is more common)

- parallel option passed to calcLogLik to compute Monte Carlo log-likelihood more quickly. Can also
  be passed down the call stack from confmirt, multipleGroup, and mixedmirt

- Confidence envelopes option added to itemplot() for trace lines and information plots

- lbound and ubound parameter bounds are now available to the user for restricting the parameter
  estimation space

- mod2values() function added to convert an estimated mirt model into the appropriate data.frame
  used to determine parameter estimation characteristics (starting values, group names, etc)

- added imputeMissing() function to impute missing values given an estimated mirt model. Useful
  for checking item and person fit diagnostics and obtaining overall model fit statistics

- allow for Rasch itemtype in multidimensional confirmatory models

- oblimin the new default exploratory rotation (suggested by Dave Flora)

- more flexible calculation of M2 statistic in fitIndicies(), with user prompt option if the internal
  variables grow too large and cause time/RAM problems

## BUG FIXES

- read.mirt() fixed when objects contain standard errors (didn't properly
  line up before)

- mixedmirt() fix when COV argument supplied (reported by Aaron Kaat)

- fix for multipleGroup when independent groups don't contain all potential response options
  (reported by Scot McNary)

- prevent only using 'free_means' and 'free_varcov' in multipleGroup since this would not be
  identified without further constraints (reported by Ken Beath)


# Changes in mirt 0.5.0


- all dichotomous, graded rating scale, (generalized) partial credit, rating scale, and nominal models
  have been better optimized

- wald() will now support information matrices that contain constrained parameters

- confmirt.model() can accept a string inputs, which may be useful for knitr/sweave documents
  since the scan() function tends to hang

- multipleGroup() now has the logical options bfactor = TRUE to use the dimensional reduction algorithm
  for when the factor pattern is structured like a bifactor model

- new fitIndices() function added to compute additional model fit statistics such as M2

- testinfo() function added for test information

- lower bound parameters under more stringent control during estimation and are bounded to never
  be higher than .6

- infit and outfit stats in itemfit() now work for Rasch partial credit and rating scale models

- Rasch rating scale models can now be estimated with potential rsm.blocks (same as grsm model).
  "Generalized" rating scale models can also be estimated, though this requires manipulating the
  starting values directly

- added AICc and sample size adjusted BIC (SABIC) information statistics

- new mixedmirt() function for estimating IRT models with person and item level (e.g., LLTM) covariates.
  Currently only supports fixed effect predictors, but random effect predictors are being developed

- more structured output when using the anova() generic

- standard errors no longer slightly positively biased when parameter constraints are imposed

# Changes in mirt 0.4.2

- item probability functions now only permit permissible values, and models may converge even when
  the log-likelihood decreases during estimation. In the EM if the model does not have a strictly
  increasing log-likelihood then a warning message will be printed

- infit and outfit statistics are now only applicable to Rasch models (as they should be),
  and in itemfit/personfit() a 'method' argument has been added to specify which factor score
  estimates should be used

- read.mirt() re-added into the package to allow for translating estimated models into a format
  usable by the plink package

- test standard error added to plot() generic using type = 'SE', and expected score plot added
  to itemplot() using type = 'score'

- weighted likelihood estimation (WLE) factor scores now available (without standard errors)

- removed the allpars option to coef() generics and only return a named list with the (possibly
  rotated) item and group coefficients

- information functions slightly positively biased due to logistic constant adjustment,
  fixed for all models. Also, information functions are now available for almost all item response models
  (mcm items missing)

- constant (D) used in estimating logistic functions can now be modified (default is still 1.702)

- partcomp models recently broken, fixed now

- more than one parameter can now be passed to parprior to make specifying identical priors more
  convenient

# Changes in mirt 0.4.1

- relative efficiency plots added to itemplot(). Works directly for multipleGroup analysis
  and for comparing different item types (e.g., 1PL vs 2PL) can be wrapped into a named list

- infit and outfit statistics added to personfit() and itemfit()

- empirical reliability printed for each dimension when fscores(..., fulldata = FALSE) called

- better system to specify fixed/free parameters and starting values using
  pars = 'values'. Should allow for much better simulation based work

- graded model type rating scale added (Muraki, 1990) with optional estimation 'blocks'. Use
  itemtype = 'grsm', and the grsm.block option

- for multipleGroup(), optional input added to change the current freely estimated parameters
  to values of a previously computed model. This will save needless iterations in the EM and MHRM
  since these parameters should be much closer to the new ML estimates

- itemplot() supports multipleGroup objects now

- analytical derivatives much more stable, although some are not yet optimized

- estimation bug fix in bfactor(), and slight bias fix in mirt() estimation (introduced in version
  0.4.0 when multipleGroup() added)

- updated documentation and beamer slide show included for some background on MIRT and some
  of the packages capabilities

- labels added to coef() when standard errors not computed. Also allpars = TRUE is now the default

- kernel estimation moved entirely to one method. Much easier to maintain and guarantees consistency
  across methods (i.e., no more quasi-Newton algorithms used)

# Changes in mirt 0.4.0

- Added itemfit() and personfit() functions for uni and multidimensional models. Within itemfit
  empirical response curves can also be plotted for unidimensional models

- Wrapped itemplot() and fscores() into S3 function for better documentation. Also response curve
  now are all contained in individual plots

- Added free.start list option for all estimation functions. Allows a quicker way to
  specify free and fixed parameters

- Added iteminfo() and extract.item() to calculate the item information and extract
  desired items

- Multiple group estimation available with the multipleGroup() function. Uses the EM and MHRM
  as the estimation engines. The MHRM seems to be faster at two factors+
  though and naturally should be more accurate, therefore it is set as the default

- wald() function added for testing linear constraints. Useful in situations
  for testing sets of parameters rather than estimating a new model for a likelihood ratio test

- Methods that use the MHRM can now estimate the nominal, gpcm, mcm, and 4PL models

- fscores computable for multiple group objects and in general play nicer with missing data
  (reported by Judith Conijn). Also, using the options full.scores = TRUE has been optimized
  with Rcpp

- Oblique rotation bug fix for fscores and coef (reported by Pedro A. Barbetta)

- Added the item probability equations in the ?mirt documentation for reference

- General bug fixes as usual that were spawned from all the added features. Overall, stay frosty.

# Changes in mirt 0.3.1

- Individual classes now correspond to the type of methods: ExploratoryClass,
  ConfirmatoryClass, and MultipleGroupClass

- plot and itemplot now works for confmirt objects

- mirt can now make use of confmirt.model specified objects and hence be confirmatory as well

- stochastic estimation of factor scores removed entirely, now only quadrature based methods
  for all objects. Also, bfactor returned objects now will estimate all the factors scores instead
  of just the general dimension

- Standard errors for mirt now automatically calculated (borrowed from running a tweaked
  MHRM run)

# Changes in mirt 0.3.0

- radically changed the underlying mechanisms for the
  estimation functions and in doing so have decided that polymirt() was
  redundant and could be replaced completely by calling confmirt(data, number_of_factors). The
  reason for the change was to facilitate a wider range or MIRT models and to allow for easier
  extensions to future multiple group analysis and multilevel modelling

- new univariate and MV models are available, including the 1-4 parameter logistic
  generalized partial credit, nominal, and multiple choice models. These are called by specifying a character
  vector called 'itemtype' of length nitems with the options '2PL','3PL','4PL','graded','gpcm',
  'nominal', or 'mcm'; use 'PC2PL' and 'PC3PL' for partially-compensatory items. If itemtype = '1PL' or 'Rasch',
  then the 1-parameter logistic/1-parameter ordinal or Rasch/partial credit models are estimated for
  all the data. The default assumes that items are either '2PL' or 'graded', as before.

- flexible user defined linear equality restrictions may be imposed on all estimation functions,
  so too can prior parameter distributions, start values, and choice of which parameters to
  estimate. These all follow these general 2 steps:

    1) Call the function as you would normally would but use, for example,
       mirt(data, 1, startvalues = 'index') to return the start values as they are indexed
    2) Edit them as you please (without changing the structure), then input them back into
       the function as mirt(data, 1, startvalues = editedstartvalues).

  This is true for the parprior (MAP priors), constrain (linear equality constraints), and
  freepars (parameters freely estimated), each with their own little quirk. All inputs are lists
  with named parameters for easy identification and manipulation. Note that this means that
  the partial credit model and Rasch models may be calculated
  as well by modifying either the start values and constraints accordingly (e.g., constrain all
  slopes to be equal to 1/1.702 and not freely estimated for the classical Rasch model, or all equal
  but estimated for the 1PL model)

- number of confmirt.model() options decreased due to the new way to specify item types, startvalues, prior
  parameter distributions, and constraints

- plink package has not kept up with item information curves, so I'll implement my own for now.
  Replaced plink item plots from 'itemplots' function with ones that I rolled

- package descriptions and documentation updated

- coef() now prints slightly different output, with the new option 'allpars = TRUE' to display all
  the item and group parameters, returned as a list

- simdata() updated to support new item types

- more accurate standard errors for MAP and ML factor scores, and specific factors in bfactorClass
  objects can now be estimated for all methods

# Changes in mirt 0.2.6-1

- dropped the ball and had lots of bug fixes this round. Future
  commits will avoid this problem by utilizing the testthat package
  to test code extensively before release

- internal change in confmirt function to move MHRM engine outside the
  function for better maintenance

- theta_angle added to mirt and polymirt plots for changing the viewing angle
  w.r.t theta_1

- null model no longer calculated when missing data present

- fixed item slope models estimated in mirt() with associated standard errors

# Changes in mirt 0.2.6

- null model computed, allowing for model statistics such as TLI

- documentation changes

- many back end technical details about estimation moved to technical lists

- support for all GPArotation methods and options, including Target rotations

- polymirt() uses confmirt() estimation engine

- 4PL support for mirt() and bfactor(), treating the upper bound as fixed

- coef() now has a rotate option for returning rotated IRT parameters

# Changes in mirt 0.2.5

- Fixed translation bug in the C++ code from bfactor() causing illegal
  vector length throw

- Fixed fscores() bug when using polychotomous items for mirt() and
  bfactor()

- pass rotate='rotation' from mirt and polymirt to override default
  'varimax' rotation at estimation time (suggested by
  Niels Waller)

- RMSEA, G^2, and p set to NaN instead of internal placeholder when
  there are missing data

- df adjusted when missing data present

- oblique rotations return invisible factor correlation matrix

# Changes in mirt 0.2.4

- degrees of freedom correctly adjusted when using noncompensatory
  items

- confmirtClass reorganized to work with S4 methods, now work
  more consistently with methods.

- fixed G^2 and log-likelihood in logLik() when product terms included

- bugfix in drawThetas when noncompensatory items used

# Changes in mirt 0.2.3

- bugfixes for fscores, itemplot, and generic functions

- read.mirt() added for creating a suitable plink object

- mirt() and bfactor() can now accommodate polychotomous items using
  an ordinal IRT scheme

- itemplot() now makes use of the handy plink package plots, giving a
  good deal of flexibility.

- Generic plot()'s now use lattice plots extensively

# Changes in mirt 0.2.2

- Ported src code into Rcpp for future tweaking.

- Added better fitted() function when missing data exist (noticed by
  Erin Horn)

# Changes in mirt 0.2.1

- ML estimation of factor scores for mirt and bfactor

- RMSEA statistic added for all fitted models

- Nonlinear polynomial estimation specification for confmirt models, now
  with more consistent returned labels

- Provide better identification criteria for confmirt() (suggested by
  Hendrik Lohse)

# Changes in mirt 0.2.0

- parameter standard errors added for mirt() (1 factor only) and bfactor() models

- bfactor() values that are ommited are recoded to NA in summary and coef
  for better viewing

- 'technical' added for confmirt function, allowing for various tweaks and
  varying beta prior weights

- product relations added for confmirt.model(). Specified by enclosing in brackets
  and using an asterisk

- documentation fixes with roxygenize

# Changes in mirt 0.1.20

- allow lower bound beta priors to vary over items (suggested by James Lee)

# Changes in mirt 0.1.6

- bias fix for mirt() function (noticed by Pedro Barbetta)
