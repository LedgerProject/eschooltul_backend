import React, { useEffect, useState } from 'react';
import _ from 'lodash/fp';
import Rails from '@rails/ujs';
import getCourseMembers from './utils/grades';
import TermSelector from './filters/TermSelector';
import Table from './table/Table';
import GradesFooter from './GradesFooter';
import convertToCSV from './utils/convertToCSV';
import EmptyStudents from './EmptyStudents';

const getCurrentStudent = (data, studentID) => (
  data.students[_.findIndex(['id', studentID])(data.students)]
);

const findMark = (marks, mark) => (
  _.findIndex({
    remarkable_id: mark.remarkable_id,
    remarkable_type: mark.remarkable_type,
  })(marks)
);

const MARK_IS_PROPER_DEFINED = new RegExp(/^(\d{1}(\.\d{1,2})?|10)$/);

const getMarks = _.flow(
  _.get('students'),
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

const Grades = ({ course, saveURL }) => {
  const [data, setData] = useState(course);
  const [selectedTerm, setSelectedTerm] = useState(undefined);
  const [courseMembers, setCourseMemebers] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    setIsLoading(true);
    setCourseMemebers(getCourseMembers(course, selectedTerm));
    setIsLoading(false);
  }, [selectedTerm, data, course]);

  const onSelectedTerm = (e) => {
    setSelectedTerm(
      _.isUndefined(e.target.value)
        ? undefined
        : course.terms[e.target.value],
    );
  };

  const onValueChange = (newMark) => {
    const newData = { ...data };
    const currentStudent = getCurrentStudent(newData, newMark.student_id);
    const markIndex = findMark(currentStudent.marks, newMark);
    if (_.lt(markIndex, 0)) {
      currentStudent.marks.push(newMark);
      setData({ ...newData });
      return;
    }

    currentStudent.marks[markIndex].value = newMark.value;
    setData({ ...newData });
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

  if (_.isEmpty(courseMembers)) {
    return <EmptyStudents />;
  }

  if (isLoading) {
    return null;
  }

  return (
    <>
      { !_.isEmpty(course.terms) && (
        <TermSelector
          terms={course.terms}
          selectedTerm={selectedTerm}
          onSelectedTerm={onSelectedTerm}
        />
      )}
      <Table
        courseMembers={courseMembers}
        selectedTerm={selectedTerm}
        course={course}
        onValueChange={onValueChange}
      />
      <GradesFooter
        onSave={onSave}
        dataCSV={dataCSV}
        courseName={course.name + course.subject}
      />
    </>
  );
};

export default Grades;
