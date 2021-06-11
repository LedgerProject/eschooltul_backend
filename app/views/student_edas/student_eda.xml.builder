xml.instruct! :xml, encoding: "UTF-8"
xml.schema do
  xml.import do
    xml.simpleType(name: "AcademicYearType") do
      xml.annotation do
        xml.documentation(@student_eda.year_of_study, type: "integer")
      end
    end
    xml.simpleType(name: "StudentCode") do
      xml.annotation do
        xml.documentation(@student_eda.student_code, type: "string")
      end
    end
    xml.simpleType(name: "ModeOfStudy") do
      xml.annotation do
        xml.documentation(@student_eda.mode_of_study, type: "string")
      end
    end
    xml.simpleType(name: "ModeOfDelivery") do
      xml.annotation do
        xml.documentation(@student_eda.mode_of_delivery, type: "string")
      end
    end
    xml.simpleType(name: "Language") do
      xml.annotation do
        xml.documentation(@student_eda.language, type: "string")
      end
    end
    xml.simpleType(name: "EmailAddress") do
      xml.annotation do
        xml.documentation(@student_eda.email_address, type: "string")
      end
    end
    xml.simpleType(name: "CertificationDate") do
      xml.annotation do
        xml.documentation(@student_eda.certification_date, type: "date")
      end
    end
    xml.simpleType(name: "CourseUnitType") do
      xml.annotation do
        xml.documentation(@student_eda.course_unit_type, type: "string")
      end
    end
    xml.simpleType(name: "Date") do
      xml.annotation do
        xml.documentation(@student_eda.date, type: "date")
      end
    end
    xml.simpleType(name: "ECTSGracingScaleType") do
      xml.annotation do
        xml.documentation(@student_eda.ECTS_grading_scale_type, type: "string")
      end
    end
    xml.simpleType(name: "Country") do
      xml.annotation do
        xml.documentation(@student_eda.country, type: "string")
      end
    end
    xml.simpleType(name: "NationalFrameworkQualifications") do
      xml.annotation do
        xml.documentation(@student_eda.national_framework_qualifications, type: "string")
      end
    end
    xml.simpleType(name: "Percent") do
      xml.annotation do
        xml.documentation(@student_eda.percent, type: "float")
      end
    end
    xml.simpleType(name: "GradeSource") do
      xml.annotation do
        xml.documentation(@student_eda.source_grade, type: "string")
      end
    end
    xml.simpleType(name: "FameworkCode") do
      xml.annotation do
        xml.documentation(@student_eda.framework_code, type: "string")
      end
    end
    xml.simpleType(name: "GroupIdentifier") do
      xml.annotation do
        xml.documentation(@student_eda.group_identifier, type: "string")
      end
    end
    xml.simpleType(name: "InstitutionIdentifier") do
      xml.annotation do
        xml.documentation(@student_eda.institution_identifier, type: "string")
      end
    end
    xml.simpleType(name: "SuplemetnLanguage") do
      xml.annotation do
        xml.documentation(@student_eda.suplement_language, type: "string")
      end
    end
    xml.simpleType(name: "Gender") do
      xml.annotation do
        xml.documentation(@student_eda.gender, type: "string")
      end
    end
    xml.simpleType(name: "SourceCourseCode") do
      xml.annotation do
        xml.documentation(@student_eda.source_course_code, type: "string")
      end
    end
    xml.simpleType(name: "NumberOfYears") do
      xml.annotation do
        xml.documentation(@student_eda.number_of_years, type: "integer")
      end
    end
  end
end
