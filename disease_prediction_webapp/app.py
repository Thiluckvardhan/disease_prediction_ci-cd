from flask import Flask, request, render_template
import joblib
import numpy as np
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent

model1 = joblib.load(BASE_DIR / 'model_decision_tree_gini.pkl')
model2 = joblib.load(BASE_DIR / 'model_decision_tree_entropy.pkl')
le = joblib.load(BASE_DIR / 'label_encoder.pkl')

severity_df = pd.read_csv(BASE_DIR / 'Symptom-severity.csv')
desc_df = pd.read_csv(BASE_DIR / 'symptom_Description.csv')
prec_df = pd.read_csv(BASE_DIR / 'symptom_precaution.csv')

severity_df['Symptom'] = severity_df['Symptom'].astype(str).str.strip().str.replace(' ', '_').str.lower()
symptoms_list = sorted(severity_df['Symptom'].unique())

desc_df['key'] = desc_df['Disease'].astype(str).str.strip().str.lower()
prec_df['key'] = prec_df['Disease'].astype(str).str.strip().str.lower()

app = Flask(
    __name__,
    template_folder=str(BASE_DIR / 'templates'),
    static_folder=str(BASE_DIR / 'static')
)

@app.route('/')
def index():
    return render_template('index.html', symptoms=symptoms_list)

@app.route('/predict', methods=['POST'])
def predict():
    selected_symptoms = [s.strip().lower() for s in request.form.getlist('symptoms')]
    x = np.array([1 if s in selected_symptoms else 0 for s in symptoms_list]).reshape(1, -1)

    p1 = model1.predict(x)[0]
    p2 = model2.predict(x)[0]
    final_idx = np.bincount([p1, p2]).argmax()
    final_pred = le.inverse_transform([final_idx])[0]
    key = str(final_pred).strip().lower()

    desc_series = desc_df.loc[desc_df['key'] == key, 'Description']
    description_text = desc_series.iloc[0] if not desc_series.empty else "No description available."

    row = prec_df.loc[prec_df['key'] == key]
    precaution_list = []
    if not row.empty:
        vals = row.iloc[0].tolist()[1:]
        precaution_list = [v for v in vals if pd.notna(v) and str(v).strip()]

    return render_template(
        'result.html',
        disease=str(final_pred).title(),
        description=description_text,
        precautions=precaution_list
    )

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
