import _ from 'lodash/fp';

const remarkable_types = {
  lesson: 'Lesson',
  term: 'Term',
  course: 'Course'
};

const createMark = (id, value, student_id, remarkable_type, remarkable_id ) => (
  {
    id: id,
    value: value,
    student_id: student_id,
    remarkable_type: remarkable_type,
    remarkable_id: remarkable_id
  }
);

const findMark = (marks, student_id, remarkable_type, remarkable_id) => {
  const markIndex = _.findIndex({
    student_id: student_id,
    remarkable_id: remarkable_id,
    remarkable_type: remarkable_type,
  })(marks)

  if(_.lt(markIndex, 0)) {
    return createMark(null, null, student_id, remarkable_type, remarkable_id);
  }

  return createMark(
      marks[markIndex].id,
      marks[markIndex].value, 
      marks[markIndex].student_id, 
      marks[markIndex].remarkable_type, 
      marks[markIndex].remarkable_id
    );
};

const flatAllMarks = _.flow(
  _.flatMap('marks')
);

const setLessons = (lessons, marks, student_id) => (
  _.map((lesson) => {
    return {
      lesson: lesson,
      mark: findMark(marks, student_id, remarkable_types.lesson, lesson.id)
    }
  })(lessons)
);

const setTerms = (terms, lessons, marks, student_id) => (
  _.map((term) => {
    return {
      term: term,
      lessons: setLessons(_.filter(['term_id', term.id])(lessons), marks, student_id),
      termMark: findMark(marks, student_id, remarkable_types.term, term.id),
    }
  })(terms)
);

const studentsWithoutTerms = (course, marks) => (
  _.map((student) => {
    return {
      student: student,
      lessons: setLessons(course.lessons, marks, student.id),
      courseMark: findMark(marks, student.id, remarkable_types.course, course.id),
    }
  })(course.students)
);

const studentsWithTerms = (course, marks, selectedTerm) => (
  _.map((student) => {
    const terms = (
      _.isUndefined(selectedTerm) ? course.terms : _.filter(['id', selectedTerm.id])(course.terms)
    );
    return {
      student: student,
      terms: setTerms(terms, course.lessons, marks, student.id, course.id),
      lessons: setLessons(_.filter(['term_id', null])(course.lessons), marks, student.id),
      courseMark: findMark(marks, student.id, remarkable_types.course, course.id),
    }
  })(course.students)
);


const setCourseStudents = (course, selectedTerm) => {
  const marks = flatAllMarks(course.students);
  if(_.isEmpty(course.terms)){
    return studentsWithoutTerms(course, marks); 
  }
  return studentsWithTerms(course, marks, selectedTerm);
}

export default setCourseStudents;
