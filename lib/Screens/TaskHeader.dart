import 'package:flutter/material.dart';
import 'package:todo_app/util/themeProvider.dart';
import 'package:provider/provider.dart';

class Taskheader extends StatefulWidget {
  final VoidCallback onAddPressed;
  final bool isExpanded;
  const Taskheader({super.key, required this.onAddPressed, required this.isExpanded});

  @override
  State<Taskheader> createState() => _TaskheaderState();
}


class _TaskheaderState extends State<Taskheader> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final Color headerColor = themeProvider.isDarkMode 
      ? const Color(0xFF311B92) // A much darker deep purple for dark mode
      : const Color(0xFF9161E0);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // 1. THE PURPLE SECTION
        Container(
          height: 180, 
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          color: headerColor,
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.grid_view_rounded, color: Colors.white),
                    const Text('To-Do', 
                      style: TextStyle(color: Colors.white, fontFamily: 'Unbounded', fontWeight: FontWeight.bold)),

                    IconButton(
                      icon: Icon(
                  
                        themeProvider.isDarkMode ? Icons.lightbulb_outline : Icons.lightbulb,
                      ),
                      
                      color: themeProvider.isDarkMode 
                          ? Colors.white 
                          : Colors.yellow, 
                      onPressed: () {
                        themeProvider.toggleTheme(!themeProvider.isDarkMode);
                      },
                    )],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Welcome', 
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Georama')),
                    ElevatedButton(
                      onPressed: widget.onAddPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isExpanded 
                        ? (themeProvider.isDarkMode ? const Color.fromARGB(255, 190, 190, 190) : Colors.grey[200]) 
                        : (themeProvider.isDarkMode ? Colors.grey[300] : Colors.white),
                        foregroundColor: const Color(0xFF311B92),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: themeProvider.isDarkMode ? 0 : 2,
                      ),
                      child: Text(widget.isExpanded ? 'Close' : 'Add New'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),

        // 2. THE WHITE SECTION (With "My Tasks" inside)
        Container(
          color: headerColor, // The purple background for the curve
          child: Container(
            width: double.infinity,
            decoration:  BoxDecoration(
              color: isDark ? Color(0xFF121212) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
              ),
            ),
            // Padding here controls exactly where "My Tasks" sits
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 24, bottom: 10),
              child: Text(
                'My Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color(0xFF121212),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}