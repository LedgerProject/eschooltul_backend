import React, { useEffect, useState } from 'react';
import _ from 'lodash/fp';
import Rails from '@rails/ujs';
import getCourseMembers from './utils/grades';
import CourseSelector from './filters/CourseSelector';
import TermSelector from './filters/TermSelector';
import Table from './table/Table';
import GradesFooter from './GradesFooter';
import convertToCSV from './utils/convertToCSV';
import I18n from '../../i18n-js/index.js.erb';

const getCurrentStudent = (data, selectedCourseID, studentID) => {
  const course = data[_.findIndex(['id', selectedCourseID])(data)];
  return course.students[_.findIndex(['id', studentID])(course.students)];
};

const findMark = (marks, mark) => (
  _.findIndex({
    remarkable_id: mark.remarkable_id,
    remarkable_type: mark.remarkable_type,
  })(marks)
);

const MARK_IS_PROPER_DEFINED = new RegExp(/^(\d{1}(\.\d{1,2})?|10)$/);

const getMarks = _.flow(
  _.flatMap('students'),
  _.flatMap('marks'),
  _.filter((mark) => MARK_IS_PROPER_DEFINED.test(mark.value) || _.isEmpty(mark.value)),
  _.map((mark) => ({
    remarkable_id: mark.remarkable_id,
    remarkable_type: mark.remarkable_type,
    student_id: mark.student_id,
    value: _.isEmpty(mark.value) ? null : parseFloat(mark.value),
  })),
  _.compact,
);

const Grades = ({ courses, saveURL }) => {
  const [data, setData] = useState(courses);
  const [selectedCourse, setSelectedCourse] = useState(courses[0]);
  const [selectedTerm, setSelectedTerm] = useState(undefined);
  const [courseMembers, setCourseMemebers] = useState([]);

  useEffect(() => {
    setCourseMemebers(getCourseMembers(selectedCourse, selectedTerm));
  }, [selectedCourse, selectedTerm, data]);

  const onSelectedCourse = (e) => {
    setSelectedTerm(undefined);
    setSelectedCourse(courses[e.target.value]);
  };

  const onSelectedTerm = (e) => {
    setSelectedTerm(
      _.isUndefined(e.target.value)
        ? undefined
        : selectedCourse.terms[e.target.value],
    );
  };

  const onValueChange = (newMark) => {
    const newData = [...data];
    const currentStudent = getCurrentStudent(newData, selectedCourse.id, newMark.student_id);
    const markIndex = findMark(currentStudent.marks, newMark);
    if (_.lt(markIndex, 0)) {
      currentStudent.marks.push(newMark);
      setData([...newData]);
      return;
    }

    currentStudent.marks[markIndex].value = newMark.value;
    setData([...newData]);
  };

  const onSave = () => {
    const marks = getMarks(data);
    const params = new FormData();
    params.append('marks', JSON.stringify(marks));

    Rails.ajax({
      url: saveURL,
      type: 'POST',
      data: params,
      success: () => {
        // TODO: show better feedback/alert
        alert('guardado'); // eslint-disable-line
        window.location.reload();
      },
      error: () => {
        alert('Error al guardar'); // eslint-disable-line
      },
    });
  };

  const dataCSV = convertToCSV(courseMembers);

  return (
    <>
      <h1 className="text-2xl md:text-5xl font-bold tracking-tighter">{I18n.t('grades.title')}</h1>
      <p className="text-gray-400 tracking-widest mb-2">{I18n.t('grades.subtitle')}</p>
      <CourseSelector
        courses={courses}
        onSelectedCourse={onSelectedCourse}
      />
      { !_.isEmpty(selectedCourse.terms) && (
        <TermSelector
          terms={selectedCourse.terms}
          selectedTerm={selectedTerm}
          onSelectedTerm={onSelectedTerm}
        />
      )}
      <Table
        courseMembers={courseMembers}
        selectedTerm={selectedTerm}
        selectedCourse={selectedCourse}
        onValueChange={onValueChange}
      />
      <GradesFooter
        onSave={onSave}
        selectedCourseID={selectedCourse.id}
        dataCSV={dataCSV}
        courseName={selectedCourse.name + selectedCourse.subject}
      />
    </>
  );
};

export default Grades;
