#pragma once
#include <QObject>
#include "i_app_info_service.hpp"
#include "i_app_info_controller.hpp"
#include "adapters_export.hpp"

namespace adapters::controllers
{

class ADAPTERS_EXPORT AppInfoController : public IAppInfoController
{
    Q_OBJECT

public:
    AppInfoController(
        application::IAppInfoService* appInfoService);

private:
    QString getCurrentVersion() const override;
    QString getNewestVersion() const override;
    QString getApplicationName() const override;
    QString getCompanyName() const override;
    QString getWebsite() const override;
    QString getNewsWebsite() const override;
    QString getCompanyEmail() const override;
    QString getGithubLink() const override;
    QString getCurrentQtVersion() const override;
    QString getOperatingSystem() const override;
    void updateApplication() override;

    application::IAppInfoService* m_appInfoService;
};

} // namespace adapters::controllers