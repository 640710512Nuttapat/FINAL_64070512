import 'dart:convert';

import 'package:flutter/material.dart';

import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';
import '../helpers/my_text_field.dart';
import '../models/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
 @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> _todoItems = [];
  Icon myIcon = Icon(Icons.check);
  Icon emptyIcon = Icon(null);
   final TextEditingController _urlController = TextEditingController();
    final TextEditingController _detailController = TextEditingController();
  var idd;
  @override
  void initState() {
    super.initState();
    _loadTodoItems();
    
  }
  void arr(var id_test){
      idd=id_test;
      emptyIcon==myIcon;
      
  }

  Future<void> _loadTodoItems() async {
    try {
      final data = await ApiCaller().get("web_types");
      // ข้อมูลที่ได้จาก API นี้จะเป็น JSON array ดังนั้นต้องใช้ List รับค่าจาก jsonDecode()
      List list = jsonDecode(data);
      setState(() {
        _todoItems = list.map((e) => TodoItem.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
   
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Webby Fonde'),centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           Text(
            'ระบบรายงานเว็บเลว',
            style: textTheme.titleMedium,
            textAlign: TextAlign.center, 
          ),
           Text(
            '* ต้องกรอกข้อมูล',
            style: textTheme.titleMedium,
            textAlign: TextAlign.center, 
          ),
           MyTextField(
          controller: _urlController, 
          hintText: 'URL *', 
          keyboardType: TextInputType.url, 
        ),
         MyTextField(
          controller: _detailController,
          hintText: 'รายละเอียด', 
        ),
        SizedBox(height: 8.0),
        Text("ระบุประเภทเว็บไซต์เลว   *"),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  final item = _todoItems[index];
                  return InkWell(
                    
          onTap: () {
           arr(item.id);
         },
  child: Card(
    child: ListTile(
      
      leading:Image.network(
        "https://cpsu-api-49b593d4e146.herokuapp.com" + item.image,
         height: 200,
        fit: BoxFit.contain,
      ),
      title: Text(''), 
      subtitle:Text(
       "${item.title}\n ${item.subtitle}",
        style: TextStyle(fontSize: 20),
        ), 
      trailing: emptyIcon
        
      
    ),
  ),
);
                },
              ),
            ),
            const SizedBox(height: 24.0),

            // ปุ่มทดสอบ POST API
            ElevatedButton(
              onPressed: _handleApiPost,
              child: const Text('ส่งข้อมูล'),
            ),

            const SizedBox(height: 8.0),

           
          ],
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "report_web",
        params: {
          "URL":_urlController.text,
          "รายละเอียด":_detailController.text,
          'id':idd
          
},
      );
      // API นี้จะส่งข้อมูลที่เรา post ไป กลับมาเป็น JSON object ดังนั้นต้องใช้ Map รับค่าจาก jsonDecode()
      Map map = jsonDecode(data);
      String text =
          'ขอบคุณสำหรับข้อมูล รหัสข้อมูลของคุณ คือ\n\n - id: ${map['id']} \n สถิตรายงาน \n ${myIcon} เว็บพนัน :';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
    
  }

  Future<void> _handleShowDialog() async {
    await showOkDialog(
      context: context,
      title: "This is a title",
      message: "This is a message",
    );
  }
}