  class PatientProfile {
    String? firstName, lastName, userName, profileImage;
    int? completionPercentage; // Isko niche factory mein handle kiya hai
    bool? isProfileCompleted,
        dobCompleted,
        addressCompleted,
        bodyCompleted,
        photoCompleted,
        basicProfileCompleted;

    int? id;
    String? patientCode;
    bool? isActive;
    String? dob;
    String? gender;
    String? bloodGroup;
    String? address1;
    String? address2;
    String? city;
    String? state;
    String? country;
    String? pinCode;
    int? height;
    int? weight;
    String? skinColor;
    String? additionalInfo;
    String? emergencyNumber;
    String? mobile;

    PatientProfile({
      this.id,
      this.patientCode,
      this.isActive,
      this.firstName,
      this.lastName,
      this.userName,
      this.dob,
      this.gender,
      this.bloodGroup,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.country,
      this.pinCode,
      this.profileImage,
      this.height,
      this.weight,
      this.skinColor,
      this.additionalInfo,
      this.emergencyNumber,
      this.mobile,
      this.completionPercentage,
      this.isProfileCompleted,
      this.dobCompleted,
      this.addressCompleted,
      this.bodyCompleted,
      this.photoCompleted,
      this.basicProfileCompleted,
    });

    factory PatientProfile.fromJson(Map<String, dynamic> details, Map<String, dynamic> completion) {
      // Helper function to safely convert any number type to int
      int? safeInt(dynamic value) {
        if (value == null) return null;
        if (value is int) return value;
        if (value is double) return value.toInt();
        return int.tryParse(value.toString());
      }

      return PatientProfile(
        id: safeInt(details['id']),
        patientCode: details['patientCode'],
        isActive: details['isActive'],
        firstName: details['firstName'],
        lastName: details['lastName'],
        userName: details['userName'],
        dob: details['dob'],
        gender: details['gender'],
        bloodGroup: details['bloodGroup'],
        address1: details['address1'],
        address2: details['address2'],
        city: details['city'],
        state: details['state'],
        country: details['country'],
        pinCode: details['pinCode'],
        profileImage: details['profileImage'],

        // Error yahan height/weight/percentage mein ho sakta hai
        height: safeInt(details['height']),
        weight: safeInt(details['weight']),

        skinColor: details['skinColor'],
        additionalInfo: details['additionalInfo'],
        emergencyNumber: details['emergencyNumber'],
        mobile: details['mobile'],

        completionPercentage: safeInt(completion['completionPercentage']),
        isProfileCompleted: completion['isProfileCompleted'],
        dobCompleted: completion['dobCompleted'],
        addressCompleted: completion['addressCompleted'],
        bodyCompleted: completion['bodyCompleted'],
        photoCompleted: completion['photoCompleted'],
        basicProfileCompleted: completion['basicProfileCompleted'],
      );
    }
  }