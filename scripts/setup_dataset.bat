@echo off
echo ========================================
echo TELCO CUSTOMER CHURN DATASET SETUP
echo ========================================
echo.

:: Move to project root (one level above scripts folder)
cd /d %~dp0..
echo Current project directory:
cd
echo.

:: Create dataset folder if it does not exist
if not exist dataset mkdir dataset

echo Step 1: Installing Kaggle CLI...
pip install kaggle
echo.

echo Step 2: Setting up Kaggle API...
echo Please make sure you have kaggle.json file in Downloads folder
echo.

:: Check if kaggle.json exists in Downloads
if exist %USERPROFILE%\Downloads\kaggle.json (
    echo Found kaggle.json in Downloads folder
    if not exist %USERPROFILE%\.kaggle mkdir %USERPROFILE%\.kaggle
    copy /Y %USERPROFILE%\Downloads\kaggle.json %USERPROFILE%\.kaggle\
    icacls %USERPROFILE%\.kaggle\kaggle.json /inheritance:r /grant:r "%USERNAME%:(R)"
    echo Kaggle API configured successfully!
) else (
    echo ERROR: kaggle.json not found in Downloads folder
    echo Please download your Kaggle API token from:
    echo https://www.kaggle.com/account
    pause
    exit /b 1
)

echo.
echo Step 3: Downloading Telco Customer Churn Dataset...
cd dataset
kaggle datasets download -d blastchar/telco-customer-churn
echo.

echo Step 4: Extracting dataset...
tar -xf telco-customer-churn.zip

:: Rename file to standard name
if exist WA_Fn-UseC_-Telco-Customer-Churn.csv (
    ren WA_Fn-UseC_-Telco-Customer-Churn.csv customer_churn.csv
    echo File renamed to customer_churn.csv
)

:: Clean up zip file
if exist telco-customer-churn.zip del telco-customer-churn.zip

echo.
echo ========================================
echo DATASET SETUP COMPLETE!
echo ========================================
echo Dataset saved to: dataset\customer_churn.csv
echo.

cd ..
python -c "import pandas as pd; df = pd.read_csv('dataset/customer_churn.csv'); print(f'Rows: {df.shape[0]}'); print(f'Columns: {df.shape[1]}'); print(f'First 5 columns: {list(df.columns[:5])}')"
echo.
pause