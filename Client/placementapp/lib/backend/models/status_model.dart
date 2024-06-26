class StatusModel {
  final int statusId;
  final String statusName;

  StatusModel({
    required this.statusId,
    required this.statusName,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
    statusId: json["statusId"],
    statusName: json["statusName"],
  );

  Map<String, dynamic> toJson() => {
    "statusId": statusId,
    "statusName": statusName,
  };
}