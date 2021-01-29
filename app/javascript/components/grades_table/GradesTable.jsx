import React, { useEffect, useState } from 'react';
import _ from 'lodash/fp';
import CourseSelector from './CourseSelector';
import TermSelector from './TermSelector';
import setCourseStudents from './students';
import StudentsTable from './StudentsTable';

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

const GradesTable = (props) => {
  const [data, setData] = useState(props.courses);
  const [selectedCourse, setSelectedCourse] = useState(props.courses[0]);
  const [selectedTerm, setSelectedTerm] = useState(undefined);
  const [courseMembers, setcourseMembers] = useState([]);

  console.log("COURSES: ", data);

  console.log("STUDENTS: ", courseMembers);

  useEffect(() => {
    setcourseMembers(
      setCourseStudents(selectedCourse, selectedTerm)
    );
  }, [selectedCourse, selectedTerm, data]);
  
  const onSelectTerm = (e) => {
    if(e.target.value === -1){
      setSelectedTerm(undefined);  
      return;
    }
      
    setSelectedTerm(selectedCourse.terms[e.target.value]);  
  };


  const onValueChange = (newMark) => {
    console.log("MARK: ", newMark);
    const newData = [...data];
    const currentStudent = getCurrentStudent(newData, selectedCourse.id, newMark.student_id);
    const markIndex = findMark(currentStudent.marks, newMark);
    console.log(markIndex);
    if(_.lt(markIndex, 0)){
      currentStudent.marks.push(newMark);
      setData([...newData]);
      return;
    }

    currentStudent.marks[markIndex].value = newMark.value;
    setData([...newData]);


    /*if(_.isNil(newMark.id)){
      const isNew = _.map((mark) => {
        return compareMarks(newMark, mark);
      })(currentStudent.marks);
      if(_.isEmpty(_.compact(isNew))){
        currentStudent.marks.push(newMark);
      }else {
        currentStudent.marks[_.findIndex({remarkable_type: newMark.remarkable_type, remarkable_id: newMark.remarkable_id })(currentStudent.marks)].value = newMark.value;
      }
      setData([...newData]);
    } */
  };

  const onSelectedCourse = (e) => {
    setSelectedTerm(undefined); 
    setSelectedCourse(props.courses[e.target.value])
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
        selectedCourse={selectedCourse}
        onValueChange={onValueChange}
      />
    </>
  )
};

export default GradesTable;
