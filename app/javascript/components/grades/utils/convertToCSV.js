export default function convertToCSV(courseMembers) {
  const dataCSV = [];

  courseMembers.forEach((courseMember) => {
    const { student } = courseMember;
    courseMember.terms.forEach((term) => {
      term.lessons.forEach((lesson) => {
        const newLine = {
          Student: `${student.name} ${student.first_surname} ${student.second_surname}`,
          Term: term.term.name,
          Lesson: lesson.lesson.name,
          Mark: lesson.mark.value,
        };

        dataCSV.push(newLine);
      });
    });
  });

  return dataCSV;
}
