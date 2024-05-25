import streamlit as st
import pandas as pd
import plotly.express as px
import matplotlib.pyplot as plt

# Title and description for your Streamlit app
st.title("Excel Data Comparison App")
st.write("Upload an Excel file, and visualize its data with graphs and a pie chart.")

# Upload an Excel file
file = st.file_uploader("Upload an Excel file", type=["xlsx", "xls"])

if file:
    # Read the uploaded Excel file into a dataframe
    df = pd.read_excel(file, engine="openpyxl")

    # Show the first few rows of the dataframe
    st.write("Excel file data:")
    st.write(df.head())

    # Summary statistics
    st.write("Summary Statistics:")
    st.write(df.describe())

    # Data visualization
    st.write("Data Visualization:")

    # Create a bar chart for a specific column (you can customize this part)
    column_to_plot = st.selectbox("Select a column for visualization:", df.columns)
    fig = px.bar(df, x=column_to_plot, title=f"{column_to_plot} Bar Chart")
    st.plotly_chart(fig)

    # Create a scatter plot for two numerical columns
    num_columns = df.select_dtypes(include=['float64', 'int64']).columns
    if len(num_columns) >= 2:
        x_column = st.selectbox("Select X-axis column:", num_columns)
        y_column = st.selectbox("Select Y-axis column:", num_columns)
        scatter_fig = px.scatter(df, x=x_column, y=y_column, title=f"{x_column} vs. {y_column} Scatter Plot")
        st.plotly_chart(scatter_fig)
    else:
        st.warning("Insufficient numerical columns to create a scatter plot.")

    # Create a pie chart for a categorical column
    cat_columns = df.select_dtypes(include=['object']).columns
    if len(cat_columns) >= 1:
        pie_column = st.selectbox("Select a categorical column for a pie chart:", cat_columns)
        pie_data = df[pie_column].value_counts()
        fig_pie, ax_pie = plt.subplots()
        ax_pie.pie(pie_data, labels=pie_data.index, autopct='%1.1f%%', startangle=90)
        ax_pie.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.
        st.pyplot(fig_pie)
    else:
        st.warning("Insufficient categorical columns to create a pie chart.")
