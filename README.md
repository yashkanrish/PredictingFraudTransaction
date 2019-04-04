# Credit Card and Mobile Fraud Detection using Supervised Learning Algorithms

Link to data source = https://www.kaggle.com/ntnu-testimon/paysim1
 
In this project, we were trying to analyze the pattern of fraudulent transactions by making use of different modelling techniques and using the results obtained from our study we intend to predict and prevent similar fraud cases in future. According to a report published by Experian, "63% of businesses have experienced the same or more fraud losses in the past 12 months" (Full Report here: https://www.experian.com/assets/decision-analytics/reports/global-fraud-report-2018.pdf). It is therefore paramount to enhance the fraud detection mechanisms. 

## Relevance

Digitalization in the financial sector has made it more vulnerable towards frauds. Increase in number of mobile and online transactions has alarmingly exposed us to this threat. Mobile frauds are harder to predict and can go unnoticed for months. “Sometimes you may not find out about it until the account goes into arrears, and it can take months or years to fix that, not to mention the monetary expense usually entailed,” says Brian Krebs, who runs KrebsOnSecurity.com, a website focused on cybercrime and security. 


## Data Dictionary

step - maps a unit of time in the real world. In this case 1 step is 1 hour of time. Total steps 744 (30 days simulation).

type - CASH-IN, CASH-OUT, DEBIT, PAYMENT and TRANSFER.

amount - amount of the transaction in local currency.

nameOrig - customer who started the transaction

oldbalanceOrg - initial balance before the transaction

newbalanceOrig - new balance after the transaction

nameDest - customer who is the recipient of the transaction

oldbalanceDest - initial balance recipient before the transaction. Note that there is no information for customers that start with M (Merchants).

newbalanceDest - new balance recipient after the transaction. Note that there is no information for customers that start with M (Merchants).

isFraud - This is the transactions made by the fraudulent agents inside the simulation. In this specific dataset the fraudulent behavior of the agents aims to profit by taking control or customers accounts and try to empty the funds by transferring to another account and then cashing out of the system.

isFlaggedFraud - The business model aims to control massive transfers from one account to another and flags illegal attempts. An illegal attempt in this dataset is an attempt to transfer more than 200.000 in a single transaction.


## Methodology and Results

We performed feature engineering to develop new variables that helped us in our prediction. We have used three different model: logistic regression, random forest and XG boost for training our dataset and measured the performance of each model in terms of balanced accuracy, sensitivity and specificity.

In this experiment we first performed a down sampling to create an approximately 50:50 split of fraud and non-fraud transactions. And developed three models mentioned above to test and predict fraud in Transactions. We obtained .99 F1 score and 99.72% specificity

