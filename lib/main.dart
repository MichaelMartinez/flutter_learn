import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(PensionCalculator());
}

class PensionCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSPRS Pension Calculator',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: PensionCalculatorHomePage(title: 'PSPRS Pension Calculator'),
    );
  }
}

class PensionCalculatorHomePage extends StatefulWidget {
  PensionCalculatorHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PensionCalculatorHomePageState createState() =>
      _PensionCalculatorHomePageState();
}

class _PensionCalculatorHomePageState extends State<PensionCalculatorHomePage> {
  // Controllers for inputs on Tab 1
  final TextEditingController yearsController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController deathAgeController = TextEditingController();
  final TextEditingController increaseController = TextEditingController();

  // Controllers for inputs on Tab 2
  final TextEditingController dropController = TextEditingController();

  // Controllers for inputs on Tab 3
  final TextEditingController hourlyRateController = TextEditingController();
  final TextEditingController hoursPerWeekController = TextEditingController();

  // Variables for calculations
  double monthlyPension = 0;
  double basePension25 = 0;
  double basePension30 = 0;

  String resultLabel20 = "";
  String resultLabel25 = "";
  String resultLabel30 = "";
  String totalPension20Label = "";
  String totalPension25Label = "";
  String totalPension30Label = "";
  String dropResultLabel = "";
  String yearlyAccumulationLabel = "";
  String monthlySalaryLabel = "";
  String compareResultLabel = "";

  // Calculation functions to be implemented next...
  // Controllers and Variables were here...

  void calculatePension() {
    // retrieve input values
    int years = int.parse(yearsController.text);
    int salary = int.parse(salaryController.text);
    int age = int.parse(ageController.text);
    int deathAge = int.parse(deathAgeController.text);
    double increase = double.parse(increaseController.text);

    // calculate pension amount
    if (years < 20) {
      resultLabel20 = "Years worked must be at least 20.";
    } else {
      double basePension = salary * 0.5;
      double additionalPension = (years - 20) * 0.025 * salary;
      double totalPension = basePension + additionalPension;
      double monthlyPension = totalPension / 12;
      this.monthlyPension = monthlyPension;
      resultLabel20 = "Monthly Benefit: \$$monthlyPension";

      // calculate projected monthly benefit and future value based on CPI
      double cpi = 0.02;
      double projectedMonthlyPension =
          monthlyPension * pow(1 + increase / 100, deathAge - age);
      double futureValue =
          projectedMonthlyPension * pow(1 + cpi / 12, 12 * (deathAge - age));
      resultLabel20 +=
          "\nProjected Monthly Benefit: \$$projectedMonthlyPension\nFuture Value Based on CPI: \$$futureValue";
      double basePension25 = (25 * 0.025 * salary) / 12;
      this.basePension25 = basePension25;
      double basePension30 = (30 * 0.025 * salary) / 12;
      this.basePension30 = basePension30;
      resultLabel25 =
          "Monthly Benefit at 25 years of service: \$$basePension25";
      resultLabel30 =
          "Monthly Benefit at 30 years of service: \$$basePension30";

      // total pension for years of service at 20, 25, 30
      double totalPension20 =
          basePension + (20 * 0.025 * salary) * (deathAge - age);
      double totalPension25 =
          basePension + (25 * 0.025 * salary) * (deathAge - (age + 5));
      double totalPension30 =
          basePension + (30 * 0.025 * salary) * (deathAge - (age + 10));
      totalPension20Label =
          "Total Pension at 20 years of service for ${deathAge - age} years: \$$totalPension20";
      totalPension25Label =
          "Total Pension at 25 years of service for ${deathAge - (age + 5)} years (less 5 due to working longer): \$$totalPension25\nwith a difference of \$$totalPension25 - \$$totalPension20 from 20 years of service";
      totalPension30Label =
          "Total Pension at 30 years of service for ${deathAge - (age + 10)} years (less 10 due to working longer): \$$totalPension30\nwith a difference of \$$totalPension30 - \$$totalPension20 from 20 years of service";
    }
  }

  void calculateDrop() {
    // retrieve input values
    double monthly_pension = double.parse(dropController.text);

    // calculate drop program amount
    double interest_rate = 0.07;
    int years = 5;
    double monthly_rate = interest_rate / 12;
    int num_payments = years * 12;
    double drop_amount = 0;
    for (int i = 0; i < num_payments; i++) {
      drop_amount = (drop_amount + monthly_pension) * (1 + monthly_rate);
    }

    dropResultLabel =
        "Total Paid over the Course of the Pension with the Drop Program: \$$drop_amount";

    // calculate yearly accumulation and show in separate labels
    double yearly_accumulation = drop_amount / years;
    for (int i = 1; i <= years; i++) {
      String labelText = "Year $i: \$${yearly_accumulation * i}";
      yearlyAccumulationLabel = yearlyAccumulationLabel + "\n" + labelText;
    }
  }

  void calculateCompare() {
    // retrieve input values
    monthlySalaryLabel =
        "Monthly Pension at 20 years is: \$$monthlyPension and at 25 years is: \$$basePension25 and at 30 years is: \$$basePension30";
    //double monthly_salary = monthlyPension;
    double hourly_rate = double.parse(hourlyRateController.text);
    double hours_per_week = double.parse(hoursPerWeekController.text);

    // calculate equivalent hourly rate at 20 years
    double equivalent_hourly_rate = monthlyPension / (4 * hours_per_week);
    double difference = equivalent_hourly_rate - hourly_rate;

    // calculate equivalent hourly rate to make difference between 20 and 25 years
    double equivalent_hourly_rate_diff =
        (basePension25 - monthlyPension) / (4 * hours_per_week);
    double difference_diff = equivalent_hourly_rate_diff - hourly_rate;

    // display result
    if (difference <= 0) {
      compareResultLabel =
          "You are already earning enough to meet or exceed your monthly pension.";
    } else {
      compareResultLabel =
          "You would need to make at least \$$equivalent_hourly_rate per hour to meet or exceed your monthly pension in total. This is a difference of \$$difference per hour.\n However, if you retire at 20 years with $monthlyPension the equivalent hourly rate to make up the difference between 20 and 25 years is \$$equivalent_hourly_rate_diff per hour. This is a difference of \$$difference_diff per hour.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Calculate Pension'),
              Tab(text: 'Drop Program'),
              Tab(text: 'Compare Working Years'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTab1(),
            _buildTab2(),
            _buildTab3(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextField(
            controller: yearsController,
            decoration: const InputDecoration(labelText: "Years Worked:"),
          ),
          TextField(
            controller: salaryController,
            decoration:
                const InputDecoration(labelText: "Highest Salary Earned:"),
          ),
          TextField(
            controller: ageController,
            decoration:
                const InputDecoration(labelText: "Age when you retire:"),
          ),
          TextField(
            controller: deathAgeController,
            decoration:
                const InputDecoration(labelText: "Age at Which You May Die:"),
          ),
          TextField(
            controller: increaseController,
            decoration: const InputDecoration(
                labelText: "Percentage Increase per Year:"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                calculatePension();
              });
            },
            child: const Text("Calculate"),
          ),
          Text(resultLabel20, textAlign: TextAlign.right),
          Text(resultLabel25, textAlign: TextAlign.right),
          Text(resultLabel30, textAlign: TextAlign.right),
          Text(totalPension20Label, textAlign: TextAlign.right),
          Text(totalPension25Label, textAlign: TextAlign.right),
          Text(totalPension30Label, textAlign: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildTab2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextField(
            controller: dropController,
            decoration: const InputDecoration(
                labelText: "Monthly Pension Benefit in the Drop Program:"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                calculatePension();
              });
            },
            child: const Text("Calculate"),
          ),
          Text(dropResultLabel, textAlign: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildTab3() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextField(
            controller: hourlyRateController,
            decoration:
                const InputDecoration(labelText: "Hourly Rate in Menial Job:"),
          ),
          TextField(
            controller: hoursPerWeekController,
            decoration: const InputDecoration(
                labelText: "How many hours per week can you work:"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                calculatePension();
              });
            },
            child: const Text("Calculate"),
          ),
          Text(monthlySalaryLabel, textAlign: TextAlign.right),
          Text(compareResultLabel, textAlign: TextAlign.right),
          // Add labels for output data here...
        ],
      ),
    );
  }
}
