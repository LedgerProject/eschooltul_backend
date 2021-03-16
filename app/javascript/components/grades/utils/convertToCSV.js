import _ from 'lodash/fp';

export default function convertToCSV(courseMembers) {
  const dataCSV = [];

  courseMembers.forEach((courseMember) => {
    const { student } = courseMember;
    if (!_.isUndefined(student.terms)) {
      student.terms.forEach((term) => {
        if (!_.isUndefined(term.lessons)) {
          term.lessons.forEach((lesson) => {
            const newLine = {
              Student: `${student.name} ${student.first_surname} ${student.second_surname}`,
              Term: term.term.name,
              Lesson: lesson.lesson.name,
              Mark: lesson.mark.value,
            };

            dataCSV.push(newLine);
          });
        }
      });
    }
  });

  return dataCSV;
}
