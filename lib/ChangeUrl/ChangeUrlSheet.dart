import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/ChangeUrl/ChangeUrlController.dart';
import 'package:sa_common/generated/locales.g.dart';
import 'package:sa_common/utils/colors.dart';

void showChangeUrlBottomSheet() {
  final controller = Get.find<UrlController>();

  Get.bottomSheet(
    SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(Get.context!).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      LocaleKeys.change_app_URL.tr,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: 'Current URL: ',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: controller.currentUrl.value,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: controller.urlController,
                    decoration: InputDecoration(
                      hintText: 'Please Enter Url',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    onChanged: (value) {
                      // controller.validateUrl(value);
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.canSave.value ? AppColors.primary : AppColors.gray,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: controller.canSave.value ? controller.saveUrl : null,
                      child: Text(
                        LocaleKeys.button_saveButton.tr,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
