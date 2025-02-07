# Data Wrangling and Baseline Visualization Assignment

## Introduction


Once upon a time, there was a bank offering services to its customers. The services included managing of accounts, offering loans, etc.

The bank wanted to improve its services but the bank managers had only vague idea of who was a good customer (whom to offer some additional services) and who was a bad customer (whom to watch carefully to minimize the bank loses). Fortunately, the bank stored data about its clients, the accounts (transactions within several months), the loans already granted, the credit cards issued. The bank managers hoped to improve their understanding of customers and seek specific actions to improve services, however, they failed.

Your job is to prepare and analyze this data and use it to help guide the operations of a new bank that the startup you just joined as a Data Scientst is going to open.

## The Data

The data for all of the bank's operations was contained in an application that used a relational database for data storage, and the data was exported from their system into separate `CSV` files. This is a snaphot dataset, meaning it shows the values that were current at the time of the dataset export. 

The data is contained in the `data.zip` file included in this repository. **You must unzip the file**, which will create a `data/` directory inside this repository as well, and this directory is ignored by git. 

There are eight files in the `data/` and below is a description of the contents of each file. You will practice reading in data, cleaning and rearranging the data, making the data tidy, and joining datasets for the purposes of creating a dataset that is ready to be visualized.

--

`accounts.csv` contains information about the bank's accounts.

| Field Name | Description |
|------------|-------------|
| `id`| Unique record identifier |
| `district_id` | Branch location |
| `date` | Date of account opening | 
| `statement_frequency` | The frequency that statements are generated for the account

--

`clients.csv` contains information about the bank's customers. A client (customer) can have several accounts.

| Field Name | Description |
|------------|-------------|
| `id`| Unique record identifier |
| `gender` | Client's gender |
| `birth_date` | Client's birthday | 
| `district_id` | Client's location|

--

`links.csv` contains information that links customers to accounts, and wether a customer is the owner or a user in a given account.

| Field Name | Description |
|------------|-------------|
| `id`| Unique record identifier |
| `client_id` | Client identifier |
| `account_id` | Account identifier | 
| `type` | Owner or User |

--

`transactions.csv` contains all of the bank's transactions.

| Field Name | Description |
|------------|-------------|
| `id`| Unique record identifier |
| `account_id` | Account identifier | 
| `date` | Transaction date |
| `type` | Debit or Credit |
| `amount` | Amount of transaction |
| `balance` | Account balance after the transaction is excuted
| `bank` | The two letter code of the other bank if the transaction is a bank transfer | `account` | The account number of the other bank if the transaction is a bank transfer |
| `method` | Method of transaction: can be bank transfer, cash, or credit card | 
| `category` | What the transaction was for |

--

`payment_orders.csv` contains information about orders for payments to other banks via bank transfers. A customer issues an order for payment and the bank executes the payment. These payments should also be reflected in the `transactions.csv` data as debits.

| Field Name | Description |
|------------|-------------|
| `id`| Unique record identifier |
| `account_id` | Account identifier | 
| `recipient_bank` | The two letter code of the bank where the payment is going |
| `recipient_account` | The account number of at the bank where the payment is going to |
| `amount` | Amount of transaction |
| `payment_reason` | What the transaction was for |

--

`cards.csv` contains information about credit cards issued to clients. Accounts can have more than one credit card.

| Field Name | Description |
|------------|-------------|
| `id`| Unique record identifier |
| `link_id` | Entry that maps a client to an account |
| `type` | Credit Card product name (Junior, Classic or Gold) | 
| `issue_date` | Date the credit card was issued |

--

`loans.csv` contains information about loans associated with accounts. Only one loan is allowed per account.

| Field Name | Description |
|------------|-------------|
| `id` | Unique record identifier |
| `date` | The date the loan was granted |
| `amount` | The amount of the loan |
| `payments` | The monthly payment of the loan |
| `24_A`, `12_B`, etc | These fields contain information about the term of the loan, in months, wether a loan is current or expired, and the payment status of the loan. _Expired_ means that the contract is completed, wether or not the loan was paid in full or not. _Current_ means that customers are currently making payments (or not). <br/> `A` stands for an expired loan that was paid in full<br/> `B` stands for an expired loan that was not paid in full (it was in default)<br/> `C` stands for a current loan where all payments are being made<br/> `D` stands for a current loan in default due to not all payments being made

--

`districts.csv` contains demographic information and characteristics about the districts where customers and branches are located. 

| Field Name | Description |
|------------|-------------|
| `id` | Uniquie district identifier |
| `name` | District name |
| `region` | Region name |
| `population` | Number of inhabitants |
| `num_cities` | Number of cities |
| `urban_ratio` | Ratio of urban population |
| `avg_salary` | Average salary |
| `entrepreneur_1000` | Number of entrepreneurs per 1,000 inhabitants |
| `municipality_info` | An array with the number of municipalities with the following attributes:<br/>* Population < 500<br/>* Population 500-1999<br/>* Population 2000-9999<br/>* Population >= 10000 | 
| `unemployment_rate` | An array with the unemployment rate for '95 and '96 respectively | 
| `commited_crimes` | An array with the number of commited crimes for '95 and '96 respectively | 


## Tasks

This assignment will be performed in **both R and Python**. You will create two Quarto files, named 
`eda-r.qmd` and `eda-py.qmd` to perform the tasks in R and Python, respectively. These files should be able to be rendered into HTML when the repo is cloned by the instructional team, **without modification**. To wit,

- No hard-coded paths, only relative paths (or using `here` in R or `pyhere` in Python)
- All required files will be saved in the same (top-level) folder as the Quarto files

For each task, you will create a corresponding second-level header (using `##`) describing the task, and followed by code chunk(s) that will be folded on rendering, and which meets the requirements described [here](https://gu-dsan.github.io/5200-spring-2025/site-page-content/standards.html).

### Part 1: Data Wrangling

1. Make the `loans.csv` data tidy. You must account for **all** the information contained in each record (row) and that should be in their own field. Remember, for a dataset to be considered tidy, it must meet the following criteria:
	* Each variable must have its own column
	* Each observation must have its own row
	* Each type of observational unit forms a table

	You will save the tidy version of the data in `CSV` files called `loans_r.csv` and `loans_py.csv`.

2. Make the `district.csv` data tidy. You must account for all the information contained in each record (row).

	The tidy version of the data will be saved in  `CSV` files named `district_r.csv` and `district_py.csv`.

3. Build an _analytical dataset_ by combining (joining) the data from the different tables as you see fit, which will be used for the purposes of exploratory data analysis, visualization and reporting. The unit of analysis is the _account_. This dataset must contain the following information for each _account_ using the following field names:
	- `account_id`: Account number
	- `district_name`: Name of the district where the account is
	- `open_date`: Date when account was opened
	- `statement_frequency`: The frequency that statements are generated for the account
	- `num_customers`: The total number of clients associated with the account (owner and users)
	- `credit_cards`: Number of credit cards for an account or zero if none
	- `loan`: T/F if the account has a loan
	- `loan_amount`: The amount of the loan if there is one, `NA` if none
	- `loan_payments`: The amount of the loan payment if there is one, `NA` if none
	- `loan_term`: The duration of loan in months, `NA` if none
	- `loan_status`: The status of the loan (current or expired), `NA` if none 
	- `loan_default`: T/F if the loan is in default, or `NA` if none
	- `max_withdrawal`: Maximum amount withdrawn for the account 
	- `min_withdrawal`: Minimum amount withdrawn for the account 
	- `cc_payments`: Count of credit payments for the account for all cards
	- `max_balance`: Maximum balance in the account
	- `min_balance`: Minimum balance in the account


	This process will produce `CSV` files called `analytical_r.csv` and `analytical_py.csv`.

### Part 2: Exploratory Data Analysis

1. Using the _analytical dataset_ created in Part 1 as your dataset, frame a question you would like to answer using a visualization. State your question clearly and state why you think it can be answered visually. 

1. Build the visualization that you think will answer the question above. Incorporate what you have learned around design principles, visualization best practices and theming to create a professional-leve visualization. The visualizations you create in R and Python can be different, potentially utilizing the strengths of each computational framework. You may use data profiling or interactive plots if you desire in this process, but this code **must remain hidden** in the submitted rendered document, and the outputs from the data profiling process **must be included in the `.gitignore` and not be included in the Github submission**. No interactive visualizations should be included in the rendered documents that are submitted.


	* You must explicitly read from the file where you stored the analytic data (`analytical_r.csv` and `analytical_py.csv`, respectively) during this process of creating the visualization. The idea is that this code would create visualization if it, along with the stored data file, is provided to a third party who has access to a compatible computing environment and packages.

	* The final visualizations should be high-quality and **fit for publication/presentation**, one you would be proud of. They should incorporate your personal theme(s). 
	* The visualizations should be followed by a self-contained caption in English, which includes a figure number

> You may consider doing some of your exploration in a different git branch. Only the files in your `main` branch will be considered for your submission. 


### Submitting the Assignment

Make sure you commit and push your repository to GitHub! We do expect to see multiple commits as you progress through this assignment. **Only the `main` branch of the repository will be considered for grading.**

The files to be committed and pushed to the repository for this assignment are:

* `eda-r.qmd`, `eda-r.html`, `eda-py.qmd`, `eda-py.html`,`loans_r.csv`, `loans_py.csv`,`district_r.csv`, `district_py.csv`,  `analytical_r.csv`, `analytical_py.csv`. Alongside this, the folders `eda-r_files` and `eda-py_files` which contain additional files needed to properly render the Quarto documents will be included in the repository. 
* The `data/` folder is included in the `.gitignore` file. This folder should **not** appear in your submissions, though the `data.zip` file will. 
* The `.gitignore` file can be edited to include files that should not be part of the submission, as one possible strategy for doing so. 


# Grading Rubric

This assignment will be graded qualitatively and holistically using the
rubric below. The *grading philosophy* is listed in the syllabus.

*Not meeting the minimum stated standards will result in an automatic 1
grade-step drop (so from A- to B+, for example)*

----

**A (Exemplary)**

- Outstanding analytical and visual work.
- Meets all “Proficient” criteria
- Incorporates custom thematic elements consistent across the document,
  leading towards a personal brand that is professional
- Code is styled and appropriately commented so a third party could understand and run it
- The visualizations **themselves** stand on their own with appropriate context incorporated into them using appropriate titles, captions and annotations, and would be self-explanatory if extracted from the document.

**B+ to A- (Proficient)**

- Strong analytical and visual product.
- All tidy datasets are correctly tidy.
- The rendered figures are clean and professional.
- Figures include necessary titles, labels, axes, and units, as well as annotations as required.
- The **figures along with the captions** stand on their own, and can be understood if extracted from the document
- Writing is clear, error-free, and professional.
- Only required files are submitted, and the version control system is used appropriately

**B (Satisfactory)**

- Good analytical and visual product with minor issues.
- Figures + captions are not self-explanatory.
- Personal theme is not used.
- Implemented figures may lack some clarity or polish.
- All required elements (titles, labels, axes, units) are included.
- Writing is clear, with no major errors.
- Data profiling or other exploratory code is visible in the rendered file, or outputs included in the submission. These are the *only* extra non-required files included in the submission. 

**B- (Developing)**

- Decent effort but with noticeable gaps.
- The question(s) posed is answerable from the data but is not insightful.
- Figures may lack clarity or completeness, and required elements (e.g.,
  titles, labels) might be missing.
- Captions are missing.
- Writing is generally clear but could benefit from refinement.
- A few non-required files not required for the rendered documents are included in the submission.

**C (Needs Improvement)**

- Weak analytical and visual product.
- The question posed is inappropriate or not answerable from the data
- Figures have several issues that violate the principles studied in class and would be considered "bad" visualizations.
- Writing contains multiple errors, and the deliverable appears sloppy.
- Several non-required files are included in the submission, that aren't required for the rendered documents

**F (Significantly Deficient or Missing)**

- Incomplete, minimal, or missing analytical or visual product.