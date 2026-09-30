import 'dart:html';


// ============================================================
// EXPENSE MODEL
// ============================================================

class Expense {

  String name;
  double amount;
  String category;
  bool cleared;

  Expense(
      this.name,
      this.amount,
      this.category, {
        this.cleared = false,
      });

}


// ============================================================
// GLOBAL DATA
// ============================================================

List<Expense> expenses = [

  Expense(
    'College Lunch',
    180,
    'Food',
    cleared: true,
  ),

  Expense(
    'Local Train',
    80,
    'Travel',
    cleared: true,
  ),

  Expense(
    'Notebook',
    250,
    'Shopping',
  ),

];

String selectedCategory = 'All';


// ============================================================
// MAIN
// ============================================================

void main() {

  // ----------------------------------------------------------
  // DOM ELEMENT SELECTION
  // ----------------------------------------------------------

  final expenseName =
  document.querySelector('#expenseName')
  as InputElement;

  final expenseAmount =
  document.querySelector('#expenseAmount')
  as InputElement;

  final expenseCategory =
  document.querySelector('#expenseCategory')
  as SelectElement;

  final addButton =
  document.querySelector('#addButton')
  as ButtonElement;

  final expenseList =
  document.querySelector('#expenseList')
  as DivElement;

  final searchInput =
  document.querySelector('#searchInput')
  as InputElement;

  final totalAmount =
  document.querySelector('#totalAmount')
  as DivElement;

  final expenseCount =
  document.querySelector('#expenseCount')
  as DivElement;

  final clearedCount =
  document.querySelector('#clearedCount')
  as DivElement;

  final categoryBreakdown =
  document.querySelector('#categoryBreakdown')
  as DivElement;

  final message =
  document.querySelector('#message')
  as DivElement;


  // ----------------------------------------------------------
  // INITIAL DISPLAY
  // ----------------------------------------------------------

  renderExpenses();

  updateStatistics();

  updateCategoryBreakdown();


  // ----------------------------------------------------------
  // ADD EXPENSE EVENT
  // ----------------------------------------------------------

  addButton.onClick.listen((event) {

    String name =
        expenseName.value?.trim() ?? '';

    String amountText =
        expenseAmount.value?.trim() ?? '';

    String category =
        expenseCategory.value ?? 'Other';


    // Validate input

    if (name.isEmpty ||
        amountText.isEmpty) {

      showMessage(
        'Please enter name and amount.',
        error: true,
      );

      return;
    }


    double? amount =
    double.tryParse(amountText);


    if (amount == null ||
        amount <= 0) {

      showMessage(
        'Please enter a valid amount.',
        error: true,
      );

      return;
    }


    // Create new expense

    Expense newExpense = Expense(
      name,
      amount,
      category,
    );


    // Add to list

    expenses.add(newExpense);


    // Clear inputs

    expenseName.value = '';

    expenseAmount.value = '';


    // Update DOM

    renderExpenses();

    updateStatistics();

    updateCategoryBreakdown();


    showMessage(
      'Expense added successfully!',
    );

  });


  // ----------------------------------------------------------
  // SEARCH INPUT EVENT
  // ----------------------------------------------------------

  searchInput.onInput.listen((event) {

    renderExpenses();

  });


  // ----------------------------------------------------------
  // FILTER BUTTONS
  // ----------------------------------------------------------

  final filterButtons =
  document.querySelectorAll('.filter-button');


  for (final element in filterButtons) {

    final button =
    element as ButtonElement;


    button.onClick.listen((event) {

      selectedCategory =
          button.dataset['category'] ?? 'All';


      // Remove active class from all buttons

      for (final item in filterButtons) {

        item.classes.remove('active');

      }


      // Add active class to selected button

      button.classes.add('active');


      renderExpenses();

    });

  }

}


// ============================================================
// RENDER EXPENSES
// ============================================================

void renderExpenses() {

  final expenseList =
  document.querySelector('#expenseList')
  as DivElement;

  final searchInput =
  document.querySelector('#searchInput')
  as InputElement;


  // ----------------------------------------------------------
  // REMOVE OLD DOM NODES
  // ----------------------------------------------------------

  expenseList.children.clear();


  String searchText =
      searchInput.value?.toLowerCase() ?? '';


  // Filter expenses

  List<Expense> filteredExpenses =
  expenses.where((expense) {

    bool matchesCategory =
        selectedCategory == 'All' ||
            expense.category == selectedCategory;


    bool matchesSearch =
    expense.name
        .toLowerCase()
        .contains(searchText);


    return matchesCategory &&
        matchesSearch;

  }).toList();


  // Empty state

  if (filteredExpenses.isEmpty) {

    DivElement empty =
    DivElement();

    empty.classes.add('empty-state');

    empty.text =
    'No expenses found.';

    expenseList.append(empty);

    return;
  }


  // ----------------------------------------------------------
  // CREATE DOM NODES
  // ----------------------------------------------------------

  for (final expense in filteredExpenses) {

    DivElement card =
    DivElement();

    card.classes.add('expense-card');


    // LEFT SIDE

    DivElement left =
    DivElement();

    left.classes.add('expense-left');


    // Icon

    DivElement icon =
    DivElement();

    icon.classes.add('expense-icon');

    icon.text =
        categoryIcon(expense.category);


    // Details

    DivElement details =
    DivElement();


    DivElement name =
    DivElement();

    name.classes.add('expense-name');

    name.text =
        expense.name;


    DivElement category =
    DivElement();

    category.classes.add('expense-category');

    category.text =
        expense.category;


    details.append(name);

    details.append(category);


    left.append(icon);

    left.append(details);


    // --------------------------------------------------------
    // RIGHT SIDE
    // --------------------------------------------------------

    DivElement right =
    DivElement();

    right.classes.add('expense-right');


    // Amount

    DivElement amount =
    DivElement();

    amount.classes.add('expense-amount');

    amount.text =
    '₹${expense.amount.toStringAsFixed(2)}';


    // Cleared button

    ButtonElement statusButton =
    ButtonElement();

    statusButton.classes.add(
      'status-button',
    );


    if (expense.cleared) {

      statusButton.classes.add(
        'cleared',
      );

      statusButton.text =
      '✓ Cleared';

    } else {

      statusButton.text =
      '○ Pending';

    }


    // --------------------------------------------------------
    // STATUS EVENT
    // --------------------------------------------------------

    statusButton.onClick.listen((event) {

      expense.cleared =
      !expense.cleared;


      // Demonstrating class manipulation

      statusButton.classes.toggle(
        'cleared',
      );


      if (expense.cleared) {

        statusButton.text =
        '✓ Cleared';

      } else {

        statusButton.text =
        '○ Pending';

      }


      updateStatistics();

    });


    // --------------------------------------------------------
    // DELETE BUTTON
    // --------------------------------------------------------

    ButtonElement deleteButton =
    ButtonElement();

    deleteButton.classes.add(
      'delete-button',
    );

    deleteButton.text =
    'Delete';


    deleteButton.onClick.listen((event) {

      // Remove from data

      expenses.remove(expense);


      // Remove DOM node

      card.remove();


      // Update page

      updateStatistics();

      updateCategoryBreakdown();


      showMessage(
        'Expense deleted.',
      );

    });


    right.append(amount);

    right.append(statusButton);

    right.append(deleteButton);


    // --------------------------------------------------------
    // COMPLETE CARD
    // --------------------------------------------------------

    card.append(left);

    card.append(right);


    // --------------------------------------------------------
    // ADD CARD TO DOM
    // --------------------------------------------------------

    expenseList.append(card);

  }

}


// ============================================================
// UPDATE STATISTICS
// ============================================================

void updateStatistics() {

  final totalAmount =
  document.querySelector('#totalAmount')
  as DivElement;

  final expenseCount =
  document.querySelector('#expenseCount')
  as DivElement;

  final clearedCount =
  document.querySelector('#clearedCount')
  as DivElement;


  double total = 0;

  int cleared = 0;


  for (final expense in expenses) {

    total += expense.amount;

    if (expense.cleared) {

      cleared++;

    }

  }


  // ----------------------------------------------------------
  // TEXT DOM MANIPULATION
  // ----------------------------------------------------------

  totalAmount.text =
  '₹${total.toStringAsFixed(2)}';

  expenseCount.text =
      expenses.length.toString();

  clearedCount.text =
      cleared.toString();

}


// ============================================================
// CATEGORY BREAKDOWN
// ============================================================

void updateCategoryBreakdown() {

  final container =
  document.querySelector(
    '#categoryBreakdown',
  ) as DivElement;


  container.children.clear();


  if (expenses.isEmpty) {

    container.text =
    'No spending data available.';

    return;

  }


  // Calculate total

  double total = 0;

  for (final expense in expenses) {

    total += expense.amount;

  }


  final categories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];


  for (final category in categories) {

    double categoryTotal = 0;


    for (final expense in expenses) {

      if (expense.category == category) {

        categoryTotal +=
            expense.amount;

      }

    }


    if (categoryTotal == 0) {

      continue;

    }


    double percentage =
        (categoryTotal / total) * 100;


    // --------------------------------------------------------
    // CREATE CATEGORY ROW
    // --------------------------------------------------------

    DivElement row =
    DivElement();

    row.classes.add(
      'category-row',
    );


    // Category information

    DivElement info =
    DivElement();

    info.classes.add(
      'category-info',
    );


    // --------------------------------------------------------
    // innerHtml DEMONSTRATION
    // --------------------------------------------------------

    info.innerHtml = '''
      <span>${categoryIcon(category)} $category</span>
      <strong>₹${categoryTotal.toStringAsFixed(2)}</strong>
    ''';


    // Progress container

    DivElement progress =
    DivElement();

    progress.classes.add(
      'progress',
    );


    // Progress bar

    DivElement bar =
    DivElement();

    bar.classes.add(
      'progress-bar',
    );


    // --------------------------------------------------------
    // STYLE DOM MANIPULATION
    // --------------------------------------------------------

    bar.style.width =
    '${percentage.toStringAsFixed(1)}%';


    progress.append(bar);

    row.append(info);

    row.append(progress);

    container.append(row);

  }

}


// ============================================================
// CATEGORY ICON
// ============================================================

String categoryIcon(
    String category) {

  switch (category) {

    case 'Food':
      return '🍔';

    case 'Travel':
      return '🚕';

    case 'Shopping':
      return '🛍️';

    case 'Bills':
      return '💡';

    case 'Entertainment':
      return '🎮';

    default:
      return '📦';

  }

}


// ============================================================
// MESSAGE / NOTIFICATION
// ============================================================

void showMessage(
    String text, {
      bool error = false,
    }) {

  final message =
  document.querySelector('#message')
  as DivElement;


  message.text = text;


  if (error) {

    message.style.backgroundColor =
    '#ef4444';

    message.style.color =
    'white';

  } else {

    message.style.backgroundColor =
    '#22c55e';

    message.style.color =
    '#052e16';

  }


  // Demonstrate class manipulation

  message.classes.add('show');


  // Hide after 2 seconds

  Future.delayed(
    const Duration(seconds: 2),
        () {

      message.classes.remove(
        'show',
      );

    },
  );

}