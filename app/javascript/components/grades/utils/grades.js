import _ from 'lodash/fp';
import findMark, { flatAllMarks } from './marks';
import findReport, { flatAllReports } from './reports';

const REMARKABLE_TYPES = {
  lesson: 'Lesson',
  term: 'Term',
  course: 'Course',
};

const filterLessons = (lessons, ID = null) => _.filter(['term_id', ID])(lessons);

const filterTerms = (terms, selectedTerm) => (
  _.isUndefined(selectedTerm) ? terms : _.filter(['id', selectedTerm.id])(terms)
);

const setCourseLessons = (lessons, marks, studentID) => (
  _.map((lesson) => ({
    lesson,
    mark: findMark(marks, studentID, lesson.id, REMARKABLE_TYPES.lesson),
  }))(lessons)
);

const setCourseTerms = (terms, lessons, marks, studentID) => (
  _.map((term) => ({
    term,
    lessons: setCourseLessons(filterLessons(lessons, term.id), marks, studentID),
    termMark: findMark(marks, studentID, term.id, REMARKABLE_TYPES.term),
  }))(terms)
);

const setMembersWithoutTerms = (course, data) => (
  _.map((student) => ({
    student,
    lessons: setCourseLessons(course.lessons, data.marks, student.id),
    report: findReport(data.reports, student.id, course.id),
    courseMark: findMark(data.marks, student.id, course.id, REMARKABLE_TYPES.course),
  }))(course.students)
);

const setMembersWithTerms = (course, data, selectedTerm) => (
  _.map((student) => ({
    student,
    terms: setCourseTerms(
      filterTerms(course.terms, selectedTerm), course.lessons, data.marks, student.id,
    ),
    lessons: setCourseLessons(filterLessons(course.lessons), data.marks, student.id),
    report: findReport(data.reports, student.id, course.id),
    courseMark: findMark(data.marks, student.id, course.id, REMARKABLE_TYPES.course),
  }))(course.students)
);

const getCourseMembers = (course, selectedTerm) => {
  const marks = flatAllMarks(course.students);
  const reports = flatAllReports(course.students);
  if (_.isEmpty(course.terms)) {
    return setMembersWithoutTerms(course, { marks, reports });
  }

  return setMembersWithTerms(course, { marks, reports }, selectedTerm);
};

export default getCourseMembers;
