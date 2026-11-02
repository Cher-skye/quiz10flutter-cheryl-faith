import 'package:flutter/material.dart';

void main() {
  runApp(const TaskBuddyApp());
}

class Task {
  String title;
  String subject;
  String dueDate;
  String description;

  Task({
    required this.title,
    required this.subject,
    required this.dueDate,
    this.description = '',
  });
}

// Main Application
class TaskBuddyApp extends StatelessWidget {
  const TaskBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTask',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F8FD),
        useMaterial3: true,
      ),
      home: const TaskListPage(),
    );
  }
}

// Task List Page
class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final List<Task> _tasks = [
    Task(title: 'Algebra Worksheet 5', subject: 'Math', dueDate: 'Oct 30'),
    Task(title: 'Lab Report: Photosynthesis', subject: 'Science', dueDate: 'Nov 2'),
    Task(title: 'Essay: My Hometown', subject: 'English', dueDate: 'Nov 5'),
  ];

  Future<void> _openTaskForm({Task? task, int? index}) async {
    final result = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => TaskFormPage(task: task)),
    );

    if (result != null) {
      setState(() {
        if (index == null) {
          _tasks.add(result);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Task saved successfully'),
                ],
              ),
              backgroundColor: Color(0xFF1E1F2E),
            ),
          );
        } else {
          _tasks[index] = result;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task updated successfully')),
          );
        }
      });
    }
  }

  // Delete
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete this task?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          '"${_tasks[index].title}" will be removed from your list. This can\'t be undone.',
          style: const TextStyle(color: Colors.black54),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tasks.removeAt(index);
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB02A1E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Banner Biru Atas (Gambar A)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF3F3DBC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MyTask',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_tasks.length} tasks to finish',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          
          // Daftar Task
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks yet.\nAdd your first task!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Informasi Task
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1F2E),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Label Badge Subjek (Gambar A)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: task.subject.toLowerCase() == 'math' 
                                              ? const Color(0xFFE8EAF6) 
                                              : task.subject.toLowerCase() == 'science' 
                                                  ? const Color(0xFFE8F5E9) 
                                                  : const Color(0xFFFFF3E0),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          task.subject,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: task.subject.toLowerCase() == 'math' 
                                                ? const Color(0xFF3F51B5) 
                                                : task.subject.toLowerCase() == 'science' 
                                                    ? const Color(0xFF2E7D32) 
                                                    : const Color(0xFFEF6C00),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        task.dueDate,
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Aksi Edit & Hapus (Gambar A)
                            IconButton(
                              onPressed: () => _openTaskForm(task: task, index: index),
                              icon: const Icon(Icons.edit_outlined, color: Color(0xFF3F3DBC)),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFE8EAF6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              onPressed: () => _confirmDelete(index),
                              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD32F2F)),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFFFEBEE),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      
      // Floating Action Button (FAB) (Gambar A)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openTaskForm(),
        backgroundColor: const Color(0xFF3F3DBC),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}

// Task Form Page
class TaskFormPage extends StatefulWidget {
  final Task? task;
  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subjectController;
  late TextEditingController _dateController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _subjectController = TextEditingController(text: widget.task?.subject ?? '');
    _dateController = TextEditingController(text: widget.task?.dueDate ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _dateController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      setState(() {
        _dateController.text = "${months[picked.month - 1]} ${picked.day}, ${picked.year}";
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        title: _titleController.text.trim(),
        subject: _subjectController.text.trim(),
        dueDate: _dateController.text.trim(),
        description: _descController.text.trim(),
      );
      Navigator.pop(context, task);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;

    return Scaffold(
      // Background utama form diubah menjadi ungu muda halus (sesuai gambar)
      backgroundColor: const Color(0xFFF4F5FA),
      appBar: AppBar(
        // Header/AppBar tetap warna putih bersih
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3F3DBC)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Task' : 'Add Task',
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            color: Color(0xFF1E1F2E),
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Judul Task
              const Text('Task Title', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1F2E))),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'e.g. Algebra Worksheet 5',
                  hintStyle: const TextStyle(color: Colors.black26),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFDCDDE5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFDCDDE5)),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a task title' : null,
              ),
              const SizedBox(height: 16),

              // Field Subjek
              const Text('Subject', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1F2E))),
              const SizedBox(height: 6),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'e.g. Math',
                  hintStyle: const TextStyle(color: Colors.black26),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFDCDDE5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFDCDDE5)),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a subject' : null,
              ),
              const SizedBox(height: 16),

              // Field Due Date
              const Text('Due Date', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1F2E))),
              const SizedBox(height: 6),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Select due date',
                  hintStyle: const TextStyle(color: Colors.black26),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFDCDDE5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFDCDDE5)),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please pick a due date' : null,
              ),
              const SizedBox(height: 16),

              // Field Deskripsi (Opsional)
              Row(
                children: const [
                  Text('Description ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1F2E))),
                  Text('(optional)', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Add notes about this task',
                  hintStyle: const TextStyle(color: Colors.black26),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFDCDDE5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFDCDDE5)),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Simpan (Biru/Ungu)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F3DBC),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    isEdit ? 'Save Changes' : 'Save Task',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol Batal
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: Color(0xFFDCDDE5)),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1F2E)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}