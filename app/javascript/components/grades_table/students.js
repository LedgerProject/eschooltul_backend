import _ from 'lodash/fp';
// TODO: Lessons without term when using terms
const remarkable_types = {
  lesson: 'lesson',
  term: 'term',
  course: 'course'
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
  
  const currentMark = _.compact(_.map((mark) => {
    if( _.isEqual(mark.student_id, student_id) 
      && _.isEqual(mark.remarkable_type, remarkable_type)
      && _.isEqual(mark.remarkable_id, remarkable_id) ) {
        return mark;
      }
  })(marks));
  console.log("current mark: ", currentMark);

  if(_.isEmpty(currentMark)) {
    return createMark(null, null, student_id, remarkable_type, remarkable_id);
  }

  return createMark(
      currentMark[0].id,
      currentMark[0].value, 
      currentMark[0].student_id, 
      currentMark[0].remarkable_type, 
      currentMark[0].remarkable_id
    )
};

export const flatAllMarks = _.flow(
  _.flatMap('marks')
);

const setLessons = (lessons, marks, student_id, course_id) => (
  _.map((lesson) => {
    return {
      lesson: lesson,
      mark: findMark(marks, student_id, remarkable_types.lesson, lesson.id)
    }
  })(lessons)
);

const setTerms = (terms, lessons, marks, student_id, course_id) => (
  _.map((term) => {
    return {
      term: term,
      lessons: setLessons(_.filter(['term_id', term.id])(lessons), marks, student_id, course_id),
      termMark: findMark(marks, student_id, remarkable_types.term, term.id),
    }
  })(terms)
);

const studentsWithoutTerms = (course, marks) => (
  _.map((student) => {
    return {
      student: student,
      lessons: setLessons(course.lessons, marks, student.id, course.id),
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
