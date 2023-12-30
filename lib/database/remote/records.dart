import 'dart:convert';
import 'dart:io';
import '/model/record.dart';
import 'package:http/http.dart' as http;
import '../local/records.dart';

const String url = 'http://127.0.0.1:8000/records';
// when insert a new hash set if success redis respond with the number fields
// eg (integer) 4
const int success = 4;

Future<bool> post(Record record) async {
  try {
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(record.toMap()));

    return success <= (jsonDecode(response.body) as Map)['integer'];
  } on http.ClientException {
    return false;
  }
}

Future<bool> put(Record record) async {
  final Map mapping = record.toMap();
  mapping.remove(columnId);
  try {
    final http.Response response = await http.put(
        Uri.parse('$url/${record.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(mapping));

    return success < (jsonDecode(response.body) as Map)['integer'];
  } on http.ClientException {
    return false;
  }
}

Future<bool> delete(String id) async {
  try {
    final http.Response response = await http.delete(Uri.parse('$url/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    return success == (jsonDecode(response.body) as Map)['integer'];
  } on http.ClientException {
    return false;
  }
}
