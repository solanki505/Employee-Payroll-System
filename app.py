from flask import Flask, render_template, request
import sqlite3

app = Flask(__name__)
DB = 'employee.db'

def init_db():
    conn = sqlite3.connect(DB)
    cur = conn.cursor()
    cur.execute('''
        CREATE TABLE IF NOT EXISTS Employees (
            EmployeeID INTEGER PRIMARY KEY,
            Name TEXT NOT NULL,
            Age INTEGER,
            Salary REAL,
            Department TEXT
        )
    ''')
    conn.commit()
    conn.close()

@app.route('/', methods=['GET', 'POST'])
def index():
    conn = sqlite3.connect(DB)
    cur = conn.cursor()

    message = ""
    results = []

    if request.method == 'POST':
        if 'add' in request.form:
            # Add employee
            try:
                cur.execute("INSERT INTO Employees VALUES (?, ?, ?, ?, ?)", (
                    int(request.form['emp_id']),
                    request.form['name'],
                    int(request.form['age']),
                    float(request.form['salary']),
                    request.form['department']
                ))
                conn.commit()
                message = "Employee added successfully!"
            except Exception as e:
                message = f"Error adding employee: {e}"

        elif 'search' in request.form:
            # Search by name, ID, or department
            search_type = request.form['search_by']
            keyword = request.form['keyword']

            if search_type == 'name':
                cur.execute("SELECT * FROM Employees WHERE Name LIKE ?", ('%' + keyword + '%',))
            elif search_type == 'id':
                cur.execute("SELECT * FROM Employees WHERE EmployeeID = ?", (keyword,))
            elif search_type == 'department':
                cur.execute("SELECT * FROM Employees WHERE Department LIKE ?", ('%' + keyword + '%',))

            results = cur.fetchall()
            message = f"Found {len(results)} result(s)"

        elif 'max_salary' in request.form:
            cur.execute("SELECT * FROM Employees WHERE Salary = (SELECT MAX(Salary) FROM Employees)")
            results = cur.fetchall()
            message = "Employee(s) with highest salary"

    conn.close()
    return render_template('index.html', message=message, results=results)

if __name__ == '__main__':
    init_db()
    app.run(debug=True)

