import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/attachments/model/AttachmentsModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Enums.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/colors.dart';
import 'package:sa_common/utils/constants.dart';
import 'package:sa_common/utils/pref_utils.dart';
import 'package:http/http.dart' as http;
import 'package:sa_common/utils/styles.dart';
import 'package:sa_common/widgets/primary_button.dart';

class AttachmentsController extends BaseController {
  List<AttachmentsModel> attachmentsToBeDeletedId = [];
  List<AttachmentsModel> attachments = <AttachmentsModel>[];
  List<AttachmentsModel> attachmentsMaster = <AttachmentsModel>[];
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  PrimaryButton AttachmentsButton(BuildContext context, int? masterMoneyId, GetxController controller, AttachmentsSource source) {
    return PrimaryButton(
      color: const Color.fromARGB(255, 255, 181, 181),
      text: "Attachments",
      style: TextStyle(color: Colors.red),
      minHeight: 45,
      isActive: false,
      press: () {
        showModalBottomSheet<void>(
          backgroundColor: AppColors.white,
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Attachments",
                    style: Styles.fontSmall.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Styles.xsmallVGap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          XFile? capturedImage = await captureImage();
                          if (capturedImage != null) {
                            PushingImageAttachmentsOffline(capturedImage, masterMoneyId, controller, source);
                          }
                        },
                        child: Column(
                          children: [
                            const Icon(
                              Icons.camera_rounded,
                              color: AppColors.primary,
                              size: 55,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Take a photo',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: AppColors.black,
                      ),
                      InkWell(
                        onTap: () async {
                          await PushingFileAttachmentsOffline(masterMoneyId, controller, source);
                        },
                        child: Column(
                          children: [
                            const Icon(
                              Icons.file_present,
                              color: AppColors.primary,
                              size: 55,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Upload Document',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  ListView AddedAttachmentsList(int? masterMoneyId, GetxController controller) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: attachments.isEmpty ? attachmentsMaster.length : attachments.length,
      itemBuilder: (context, index) {
        var items = attachments.isEmpty ? attachmentsMaster[index] : attachments[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 11),
          margin: EdgeInsets.symmetric(vertical: 2.5),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: const Color.fromARGB(22, 98, 189, 122),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: const Color.fromARGB(34, 117, 117, 117)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${items.name}',
                  overflow: TextOverflow.ellipsis,
                  style: Styles.fontSmall.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (items.updatedOn == null) {
                    if (items.path != null) {
                      await OpenFile.open(items.path!);
                    }
                  } else {
                    DownloadAndShowAttachment(items);
                  }
                },
                icon: Icon(
                  items.updatedOn == null ? Icons.remove_red_eye_outlined : Icons.download,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (masterMoneyId != null) {
                    attachmentsToBeDeletedId.add(items);
                    attachmentsMaster.removeAt(index);
                    controller.update();
                  } else {
                    attachments.removeAt(index);
                    DeleteAttachmentsLocal(items.path);
                    controller.update();
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: AppColors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PushingFileAttachmentsOffline(int? id, GetxController controller, AttachmentsSource source, {bool? eventPopup = false}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'gif', 'png', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'csv'],
    );
    if (result != null) {
      for (var file in result.files) {
        AttachmentsModel attachmentsModel = AttachmentsModel();
        attachmentsModel.companySlug = Helper.user.companyId;
        attachmentsModel.path = file.path;
        attachmentsModel.name = file.name;
        attachmentsModel.date = DateFormat(AppConstants.DateFormatterType).parse(DateTime.now().toString());
        attachmentsModel.source = source.name;
        if (id != null) {
          attachmentsModel.sourceId = id;
          attachmentsMaster.add(attachmentsModel);
        } else {
          attachments.add(attachmentsModel);
        }
      }
      controller.update();
      eventPopup == true ? null : (Get..back());
    }
  }

  PushingImageAttachmentsOffline(XFile imagePath, int? id, GetxController controller, AttachmentsSource source, {bool? eventPopup = false}) {
    AttachmentsModel attachmentsModel = AttachmentsModel();
    attachmentsModel.companySlug = Helper.user.companyId;
    attachmentsModel.path = imagePath.path;
    attachmentsModel.name = imagePath.name;
    attachmentsModel.date = DateFormat(AppConstants.DateFormatterType).parse(DateTime.now().toString());
    attachmentsModel.source = source.name;
    if (id != null) {
      attachmentsModel.sourceId = id;
      attachmentsMaster.add(attachmentsModel);
    } else {
      attachments.add(attachmentsModel);
    }
    controller.update();
    eventPopup == true ? null : (Get..back());
  }

  DeleteAttachmentsLocal(String? path) async {
    File files = File(path ?? "");
    files.delete();
  }

  Future<XFile?> captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, maxHeight: MediaQuery.sizeOf(this.context!).height, imageQuality: 50);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      return pickedFile;
    }
    return null;
  }

  void DownloadAndShowAttachment(AttachmentsModel attachment) async {
    var response = await this.baseClient.get(ApiEndPoint.baseUrl, "${Helper.user.companyId}/${Helper.user.branchId}/attachments/doc/${attachment.id}");
    if (response != null) {
      final documentDirectory = await getApplicationDocumentsDirectory();
      final file = await File('${documentDirectory.path}/${attachment.path!.split('/').last}').create(recursive: true);
      await file.writeAsBytes(response.bodyBytes);
      await OpenFile.open(file.path);
    }
  }

  Future<List<AttachmentsModel>?> OnlineAttachmentsPush(int id, String attachmentsSource) async {
    List<AttachmentsModel>? attachmentsResponse = [];
    var checkAttachments = attachmentsMaster.where(
      (element) {
        return element.updatedOn == null;
      },
    );

    if (checkAttachments.isNotEmpty) {
      for (var file in checkAttachments) {
        File files = new File(file.path ?? "");
        var name = file.path?.split("/").last;
        var enc = await files.readAsBytes();
        var url = "${Helper.user.companyId}/" + "${Helper.user.branchId}" + "/attachments/${attachmentsSource}/${id}";
        var param = {
          'customerId': Helper.user.customerId.toString(),
        };
        var response = await this.baseClient.postFile(ApiEndPoint.baseUrl, url, [PlatformFile(name: name ?? "", size: enc.length, path: file.path)], additionalData: param);
        var decode = AttachmentsModel().AttachmentsModelFromJson(response.body);
        attachmentsResponse.addAll(decode);
        print(decode);
      }
      return attachmentsResponse;
    }
    return attachmentsResponse = [];
  }

  DelteAttachmentsOnline() async {
    List<int?> bulkAttachmentsToBeDeletedId = [];
    PrefUtils pref = PrefUtils();
    String token = pref.GetPreferencesString(LocalStorageKey.token);
    if (attachmentsToBeDeletedId.isNotEmpty) {
      for (var attachments in attachmentsToBeDeletedId) {
        if (attachments.updatedOn != null) {
          bulkAttachmentsToBeDeletedId.add(attachments.id);
        }
      }
    }
    if (bulkAttachmentsToBeDeletedId.isNotEmpty) {
      Uri url = await Uri.parse("${ApiEndPoint.baseUrl}" + "${Helper.user.companyId}/${Helper.user.branchId}/Attachments/BulkDelete");
      var body = json.encode(bulkAttachmentsToBeDeletedId);
      var response = await http.delete(
        url,
        headers: BaseClient().GetHeader(token: token),
        body: body,
      );
      print(response.body);
    }
  }

  DeleteEventAttachmentsOnline() async {
    List<int?> bulkAttachmentsToBeDeletedId = [];
    PrefUtils pref = PrefUtils();
    String token = pref.GetPreferencesString(LocalStorageKey.token);
    if (attachmentsToBeDeletedId.isNotEmpty) {
      for (var attachments in attachmentsToBeDeletedId) {
        if (attachments.updatedOn != null) {
          bulkAttachmentsToBeDeletedId.add(attachments.id);
        }
      }
    }
    if (bulkAttachmentsToBeDeletedId.isNotEmpty) {
      for (var attachId in bulkAttachmentsToBeDeletedId) {
        Uri url = await Uri.parse("${ApiEndPoint.baseUrl}" + "${Helper.user.companyId}/${Helper.user.branchId}/attachments/${attachId}");
        var response = await http.delete(
          url,
          headers: BaseClient().GetHeader(token: token),
        );
        print(response.body);
      }
    }
  }
}
