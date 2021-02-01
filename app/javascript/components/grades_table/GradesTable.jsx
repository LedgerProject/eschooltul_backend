import React, { useEffect, useState } from 'react';
import _ from 'lodash/fp';
import CourseSelector from './CourseSelector';
import TermSelector from './TermSelector';
import setCourseStudents from './students';
import StudentsTable from './StudentsTable';
import Rails from '@rails/ujs';

const getCurrentStudent = (data, selectedCourseID, studentID) => {
  const course = data[_.findIndex(['id', selectedCourseID])(data)];
  return course.students[_.findIndex(['id', studentID])(course.students)];
};

const findMark = (marks, mark) => (
  _.findIndex({
    remarkable_id: mark.remarkable_id,
    remarkable_type: mark.remarkable_type
  })(marks)
);

const REGEXP = new RegExp(/^(\d{1}(\.\d{1,2})?|10)$/);

const getMarks = _.flow(
  _.flatMap('students'),
  _.flatMap('marks'),
  _.map((mark) => {
    if(REGEXP.test(mark.value)){
      return {
        remarkable_id: mark.remarkable_id,
        remarkable_type: mark.remarkable_type,
        student_id: mark.student_id,
        value: parseFloat(mark.value),
      }
    }
  }),
  _.compact
);

const GradesTable = (props) => {
  const [data, setData] = useState(props.courses);
  const [selectedCourse, setSelectedCourse] = useState(props.courses[0]);
  const [selectedTerm, setSelectedTerm] = useState(undefined);
  const [courseMembers, setcourseMembers] = useState([]);


  useEffect(() => {
    setcourseMembers(
      setCourseStudents(selectedCourse, selectedTerm)
    );
  }, [selectedCourse, selectedTerm, data]);

  const onSelectedCourse = (e) => {
    setSelectedTerm(undefined); 
    setSelectedCourse(props.courses[e.target.value])
  };
  
  const onSelectTerm = (e) => {
    const value = e.target.value;
    if(_.lt(value, 0)){
      setSelectedTerm(undefined);  
      return;
    }
      
    setSelectedTerm(selectedCourse.terms[value]);  
  };

  const onSave = () => {
    const marks = getMarks(data);
    console.log(marks);
    const params = new FormData();
    params.append('marks', JSON.stringify(marks));
    
    Rails.ajax({
      url: '/grades/save',
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
    })
  };

  const onValueChange = (newMark) => {
    const newData = [...data];
    const currentStudent = getCurrentStudent(newData, selectedCourse.id, newMark.student_id);
    const markIndex = findMark(currentStudent.marks, newMark);
    if(_.lt(markIndex, 0)){
      currentStudent.marks.push(newMark);
      setData([...newData]);
      return;
    }

    currentStudent.marks[markIndex].value = newMark.value;
    setData([...newData]);
  };

  return (
    <>
      <h1 className="text-2xl md:text-5xl font-bold tracking-tighter">Grades</h1>
      <p className="text-gray-400 tracking-widest mb-2">Here you can manage your grades</p>
      <CourseSelector 
        courses={props.courses}
        onSelectedCourse={onSelectedCourse}
      />
      { !_.isEmpty(selectedCourse.terms) && (
        <TermSelector 
          terms={selectedCourse.terms}
          onSelectTerm={onSelectTerm}
          selectedTerm={selectedTerm}
        />
      )}
      <StudentsTable 
        courseMembers={courseMembers}
        selectedTerm={selectedTerm}
        selectedCourse={selectedCourse}
        onValueChange={onValueChange}
        onSave={onSave}
      />
    </>
  )
};

export default GradesTable;
