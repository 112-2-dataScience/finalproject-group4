# [Group 4] Telco Customer Churn
客戶流失一直是各產業日常要面對的商業問題之一。隨著大數據時代的來臨，如何透過內外部資料有效預測和針對性減少客戶流失已然成為各企業的關注的焦點。
本次專案，我們希望能夠透過R語言建立一個有效的預測模型，幫助電信公司提前識別高風險的流失客戶，同時量化各內外部因素對於客戶流失的影響程度，進而使公司在策略發想上更具針對性。


## Contributors
|組員|系級|學號|工作分配|
|-|-|-|-|
|徐宏宇|資科三|110703056|幫忙撰寫程式| 
|周幼臻|統計三|110304030|海報設計| 
|張小明|資科碩二|xxxxxxxxx|團隊的中流砥柱，一個人打十個|

## Quick start
Please use the command below to reproduce our analysis.
```R
Rscript code/[objective.R] --input data/WA_Fn-UseC_-Telco-Customer-Churn.csv --output results/performance.tsv
```

## Folder organization and its related description
idea by Noble WS (2009) [A Quick Guide to Organizing Computational Biology Projects.](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1000424) PLoS Comput Biol 5(7): e1000424.

### docs
* Your presentation, 1122_DS-FP_groupID.ppt/pptx/pdf (i.e.,1122_DS-FP_group1.ppt), by **06.13**
* Any related document for the project, i.e.,
  * discussion log
  * software user guide

### data
* Input
  * Source
  * Format
  * Size

### code
* Analysis steps
* Which method or package do you use?
  * Random Forest
```
library(tidyverse)
library(data.table)
library(randomForest)
library(themis)
library(MASS)
library(caret)
library(car)
library(dplyr)
library(ranger)
```
  * XGBoost
```
library(tidyverse)
library(data.table)
library(randomForest)
library(themis)
library(MASS)
library(caret)
library(car)
library(dplyr)
library(ranger)
```
* How do you perform training and evaluation?
  * Cross-validation, or extra separated data
* What is a null model for comparison?

### results
* What is your performance?
* Is the improvement significant?

## References
* Packages you use
* Related publications
