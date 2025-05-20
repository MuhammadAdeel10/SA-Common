import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/generated/locales.g.dart';
import 'package:sa_common/sale_order/model/CardBaseModel.dart';
import 'package:sa_common/utils/Enums.dart';
import 'package:sa_common/utils/colors.dart';
import 'package:sa_common/utils/styles.dart';
import 'package:sa_common/utils/Helper.dart';

class ListCard<T extends CardBase> extends StatelessWidget {
  final T model;
  final Future<void> Function(T model, {required bool share}) generatePdf;
  final String Function(T model) getDateLabel;
  final String Function(T model) getDateValue;
  final Enum Function(int?) getStatusEnum;
  final Color Function(Enum) getStatusColor;

  const ListCard({
    super.key,
    required this.model,
    required this.generatePdf,
    required this.getDateLabel,
    required this.getDateValue,
    required this.getStatusEnum,
    required this.getStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    final statusEnum = getStatusEnum(model.status);
    final statusColor = getStatusColor(statusEnum);

    return Padding(
      padding: Styles.smallPadding.copyWith(bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.2, color: AppColors.primary),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            Obx(
              () => Container(
                width: 7,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: Helper.selectedLanguage.value == LanguageState.en.value ? BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)) : BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                  color: statusColor,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(LocaleKeys.date.tr, style: Styles.fontSmall.copyWith(fontSize: 12, color: AppColors.primary)),
                              Text(Helper.getFormateDate(model.date.toString()), style: Styles.fontSmall.copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(LocaleKeys.code.tr, style: Styles.fontSmall.copyWith(fontSize: 12, color: AppColors.primary)),
                            Text(model.number ?? "", style: Styles.fontSmall.copyWith(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(getDateLabel(model), style: Styles.fontSmall.copyWith(fontSize: 12, color: AppColors.primary)),
                              Text(getDateValue(model), style: Styles.fontSmall.copyWith(fontSize: 12)),
                              const Spacer(),
                              Text("${Helper.homeCurrency} ${Helper.numberFormatter.format(model.netAmount)}", style: Styles.fontSmall.copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Row(
                          children: [
                            Text("${LocaleKeys.status.tr}: ", style: Styles.fontSmall.copyWith(fontSize: 12)),
                            Text(statusEnum.name, style: TextStyle(color: statusColor)),
                          ],
                        ),
                        if (model.number != null && model.number!.isNotEmpty) ...[
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              try {
                                Helper.showLoading();
                                await generatePdf(model, share: false);
                              } finally {
                                Helper.hideLoading();
                              }
                            },
                            child: Icon(Icons.print_outlined, color: AppColors.Grey),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () async {
                              try {
                                Helper.showLoading();
                                await generatePdf(model, share: true);
                              } finally {
                                Helper.hideLoading();
                              }
                            },
                            child: Icon(Icons.send, color: AppColors.Grey),
                          ),
                        ]
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
