#include "tag.hpp"

namespace domain::entities
{

Tag::Tag(const QString& name, const QString& uuid) :
    m_name(name)
{
    if(!name.isEmpty())
        capitalizeName(m_name);

    // Generate uuid if it's not provided, else assign
    if(uuid.isEmpty())
        m_uuid = QUuid::createUuid();
    else
        m_uuid = QUuid(uuid);
}

bool Tag::operator==(const Tag& other) const
{
    return m_name == other.m_name && m_uuid == other.getUuid();
}

const QUuid& Tag::getUuid() const
{
    return m_uuid;
}

const QString& Tag::getName() const
{
    return m_name;
}

void Tag::setName(QString newName)
{
    capitalizeName(newName);
    m_name = newName;
}

bool Tag::isValid() const
{
    return m_name.size() >= 2;
}

QByteArray Tag::toJson() const
{
    QJsonObject jsonTag {
        { "name", getName() },
        { "uuid", getUuid().toString(QUuid::WithoutBraces) },
    };

    QJsonDocument jsonDoc(jsonTag);
    QString jsonString = jsonDoc.toJson(QJsonDocument::Indented);

    return jsonString.toUtf8();
}

Tag Tag::fromJson(const QJsonObject& jsonObject)
{
    QString name = jsonObject["name"].toString();
    QString guid = jsonObject["uuid"].toString();
    Tag tag(name, guid);

    return tag;
}

void Tag::capitalizeName(QString& tagName)
{
    tagName[0] = tagName[0].toUpper();
}

}  // namespace domain::entities